//
//  PredictedFundingModel.swift
//  HyperliquidDataApp
//
//  Created by Dylan Young on 7/22/25.
//

import Foundation

let jsonString =
"""
{
    [
        [
            "AAVE",
            [
                [
                    "BinPerp",
                    {
                        "fundingRate": "0.0001",
                        "nextFundingTime": 1753228800000,
                        "fundingIntervalHours": 8
                    }
                ],
                [
                    "HlPerp",
                    {
                        "fundingRate": "0.0000259841",
                        "nextFundingTime": 1753210800000,
                        "fundingIntervalHours": 1
                    }
                ],
                [
                    "BybitPerp",
                    {
                        "fundingRate": "0.0001",
                        "nextFundingTime": 1753228800000,
                        "fundingIntervalHours": 8
                    }
                ]
            ]
        ],
        [
            "ACE",
            [
                [
                    "BinPerp",
                    {
                        "fundingRate": "0.00005",
                        "nextFundingTime": 1753214400000,
                        "fundingIntervalHours": 4
                    }
                ],
                [
                    "HlPerp",
                    {
                        "fundingRate": "0.0000125",
                        "nextFundingTime": 1753210800000,
                        "fundingIntervalHours": 1
                    }
                ],
                [
                    "BybitPerp",
                    {
                        "fundingRate": "0.00005",
                        "nextFundingTime": 1753214400000,
                        "fundingIntervalHours": 4
                    }
                ]
            ]
        ]
}
"""

struct PredictedFundingModel {
    let fundingData: [[FundingAsset]]
}

struct FundingAsset {
    let asset: String
    let exchange: [[ExchangeData]]
}

struct ExchangeData {
    let fundingRate: Double
    let nextFundingTime: Double
    let fundingIntervalHours: Int
}



