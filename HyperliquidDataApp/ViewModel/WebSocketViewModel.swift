//
//  WebSocketViewModel.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 7/25/25.
//
import Combine
import Foundation

enum SubscriptionType: Hashable {
    case allMids
    case orderBook(String)
//    
//    var payload: String {
//        switch self {
//            
//        case .allMids:
//            <#code#>
//        case .orderBook(_):
//            <#code#>
//        }
//    }
}


protocol WebSocketProtocol {
    func subscribeToWebsocket(_ subscriptionType: SubscriptionType) -> AsyncStream<Result<String, Error>>
}


struct AllMidsResponse: Codable {
    let data: AllMidsData 
}

struct AllMidsData: Codable {
    let mids: [String: String]
}


class AsyncStreamDataProvider: WebSocketProtocol {
    private var socketConnection: URLSessionWebSocketTask?
    
    private var cancellable = Set<AnyCancellable>()
    
    func getAsyncStream() -> AsyncStream<Int> {
        AsyncStream { continuation in
            self.getData { price in
                continuation.yield(price)
            }
        }
    }
    
    func getData(completion: @escaping(Int) -> Void) {
        let prices = [67123, 68000, 68521, 66521, 67472]
        
        for i in 0 ..< prices.count {
            let price = prices [i]
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                completion(price)
            }
        }
    }
    
    func subscribeToWebsocket(_ subscriptionType: SubscriptionType) -> AsyncStream<Result<String, Error>> {
        let url = URL(string: "wss://api.hyperliquid.xyz/ws")!
        let subscriptionMessage = """
        {
            "method": "subscribe",
            "subscription": { "type": "allMids" }
        }
        """
        let task = URLSession.shared.webSocketTask(with: url)
        self.socketConnection = task
        return AsyncStream { continuation in
            task.resume()
            Task {
                do {
                    try await task.send(.string(subscriptionMessage))
                    while true {
                        let message = try await task.receive()
                        switch message {
                        case .string(let text):
                            continuation.yield(.success(text))
                        case .data(let data):
                            if let text = String(data: data, encoding: .utf8) {
                                continuation.yield(.success(text))
                            }
                        @unknown default:
                            continuation.yield(.failure(NSError(domain: "Unknown message", code: -1)))
                        }
                    }
                } catch {
                    continuation.yield(.failure(error))
                    continuation.finish()
                }
            }
        }
    }
    
    func stop() {
        socketConnection?.cancel(with: .normalClosure, reason: nil)
        socketConnection = nil
    }
}
@MainActor
class WebSocketViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var prices: [String: String] = [:]
    @Published var errorMessage: String? = nil
    private let dataProvider = AsyncStreamDataProvider()
    private var subscriptionTask: Task<Void, Never>? = nil

    func startSubscription() {
        isLoading = true
        subscriptionTask = Task {
            for await result in dataProvider.subscribeToWebsocket(.allMids) {
                switch result {
                case .success(let message):
                    if let data = message.data(using: .utf8),
                       let decodedResponse = try? JSONDecoder().decode(AllMidsResponse.self, from: data) {
                        DispatchQueue.main.async {
                            self.prices = decodedResponse.data.mids
                            self.isLoading = false
                            print("still fetching")
                        }
                    }
//                    DispatchQueue.main.async {
//                        self.prices = message
//                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
    
    func stopSubscription() {
        self.subscriptionTask?.cancel()
        subscriptionTask = nil
        dataProvider.stop()
        isLoading = false
    }
}


