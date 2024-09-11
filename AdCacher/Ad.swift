//
//  Ad.swift
//  InterstitialExample
//
//  Created by Ahmad Karkouti on 11/09/2024.
//  Copyright © 2024 Google. All rights reserved.
//

import Foundation

struct Ad: Equatable {
  /// The format of the ad, indicating its type (e.g., interstitial, rewarded).
  let format: AdFormat

  /// The unit ID associated with the ad. This uniquely identifies the ad placement.
  let unitId: String

  /// The ad object.
  let ad: AdType

  /// The timestamp when the ad was loaded into the cache.
  ///
  /// Used for tracking ad expiration.
  let timestamp: Date
}
