//
//  AdConfiguration.swift
//  InterstitialExample
//
//  Created by Ahmad Karkouti on 11/09/2024.
//  Copyright © 2024 Google. All rights reserved.
//

import Foundation

public struct AdConfiguration {
    /// The format of the ad (e.g., interstitial, rewarded).
    public let format: AdFormat

    /// The Ad Unit ID provided by the ad network.
    public let unitId: String

    /// The number of ads to cache for this configuration.
    public let numOfAds: Int

    /// Initializer for AdConfiguration.
    public init(format: AdFormat, unitId: String, numOfAds: Int) {
        self.format = format
        self.unitId = unitId
        self.numOfAds = numOfAds
    }
}
