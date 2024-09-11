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
  let format: AdFormat

  /// The Ad Unit ID provided by the ad network.
  let unitId: String

  /// The number of ads to cache for this configuration.
  let numOfAds: Int
}
