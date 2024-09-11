//
//  AdQueue.swift
//  InterstitialExample
//
//  Created by Ahmad Karkouti on 11/09/2024.
//  Copyright © 2024 Google. All rights reserved.
//

import Foundation
import GoogleMobileAds

struct AdQueue {
  private var ads: [Ad] = []

  /// Enqueue an ad to the end of the queue
  mutating func enqueue(_ ad: Ad) {
    ads.append(ad)
  }

  /// Dequeue an ad of a specific format from the front of the queue
  mutating func dequeue(unitId: String) -> Ad? {
    if let index = ads.firstIndex(where: { $0.unitId == unitId }) {
      return ads.remove(at: index)
    }
    return nil
  }

  /// Check if the queue is empty
  var isEmpty: Bool {
    return ads.isEmpty
  }

  /// Return the count of available ads for specified unitId
  func getCount(unitId: String) -> Int {
    return ads.filter { $0.unitId == unitId }.count
  }

  /// Remove all expired ads from the queue
  mutating func removeExpiredAds() {
    let now = Date()
    ads = ads.filter { ad in
      let expirationTime: TimeInterval = (ad.format == .appOpen ? 4 : 1) * 60 * 60
      let elapsedTime = now.timeIntervalSince(ad.timestamp)
      return elapsedTime < expirationTime
    }
  }
}
