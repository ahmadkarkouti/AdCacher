//
//  AdEnums..swift
//  InterstitialExample
//
//  Created by Ahmad Karkouti on 11/09/2024.
//  Copyright © 2024 Google. All rights reserved.
//

import Foundation
import GoogleMobileAds

public enum AdFormat: String {
  /// Interstitial ad format.
  case interstitial

  /// Rewarded ad format.
  case rewarded

  /// Rewarded interstitial ad format.
  case rewardedInterstitial

  /// App open ad format.
  case appOpen
}

public enum AdType: Equatable {
  /// Interstitial ad type.
  case interstitial(GADInterstitialAd)

  /// Rewarded ad type.
  case rewarded(GADRewardedAd)

  /// Rewarded Interstitial ad type.
  case rewardedInterstitial(GADRewardedInterstitialAd)

  /// App Open ad type.
  case appOpen(GADAppOpenAd)
}

public enum FullScreenContentType {
  /// The event when presenting full-screen content fails with an error.
  case didFailToPresentFullScreenContentWithError

  /// The event when full-screen content is about to be presented.
  case adWillPresentFullScreenContent

  /// The event when full-screen content is about to be dismissed.
  case adWillDismissFullScreenContent

  /// The event when the user clicks on the full-screen content.
  case adDidRecordClick

  /// The event when the full-screen content records an impression.
  case adDidRecordImpression

  /// The event when full-screen content is dismissed.
  case adDidDismissFullScreenContent
}
