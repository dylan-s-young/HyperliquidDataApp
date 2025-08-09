//
//  PollingTimer.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 7/20/25.
//
import Foundation

class PollingTimer {
    private var timer: Timer?
    private let interval: TimeInterval
    private let task: () -> Void
    
    init(interval: TimeInterval, task: @escaping () -> Void) {
        self.interval = interval
        self.task = task
    }
    
    func start() {
        stop()
        task()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            self.task()
        })   
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
}
