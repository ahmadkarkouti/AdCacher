//
//  AdCacher.swift
//  InterstitialExample
//
//  Created by Ahmad Karkouti on 11/09/2024.
//  Copyright © 2024 Google. All rights reserved.
//

import Foundation
import GoogleMobileAds

/// A class responsible for caching and presenting ads.
public class AdCacher: NSObject {
  private var cachedAds = AdQueue()
  private var configuration: [AdConfiguration] = []
  private var timer: Timer?
  public var onAvailable: ((_ format: AdFormat, _ unitId: String) -> Void)?
  public var onExhausted: ((_ format: AdFormat, _ unitId: String) -> Void)?
  public var onFullScreenContent:
    ((FullScreenContentType, GADFullScreenPresentingAd, Error?) -> Void)?

  // MARK: - Singleton

  public static let shared = AdCacher()

  // MARK: - Public Methods

  /// Initiates the timer for ad caching based on the given configuration an interval.
  ///
  /// - Parameters:
  ///   - configs: The ad types and ids to be cached.
  ///   - interval: The interval at which the ads to be requested.
  public func configure(configs: [AdConfiguration], interval: Double) {
    endCacher()
    configuration = configs
    timer = Timer.scheduledTimer(
      timeInterval: interval, target: self, selector: #selector(cacheAd), userInfo: nil,
      repeats: true)
    cacheAd()
  }

  /// Stops the ad caching timer.
  public func endCacher() {
    timer?.invalidate()
    timer = nil
  }

  /// Presents a full screen ad to the rootViewController.
  ///
  /// - Parameters:
  ///   - format: The ad format
  ///   - unitId: The ad unit identifier.
  ///   - fullScreenContentDelegate: The delegate to handle full screen content events.
  ///   - userDidEarnRewardHandler: The closure to be called when the user earns a reward.
  public func showAd(
    forFormat format: AdFormat, unitId: String,
    paidEventHandler: GADPaidEventHandler? = nil,
    fullScreenContentDelegate: GADFullScreenContentDelegate? = nil,
    userDidEarnRewardHandler: (() -> Void)? = nil
  ) {

    let cache = cachedAds.dequeue(unitId: unitId)
    let presenter = getPresenter()

    guard let presenter = presenter else { return }

    switch cache?.ad {
    case .interstitial(let ad):
      ad.present(fromRootViewController: presenter)
      ad.fullScreenContentDelegate = fullScreenContentDelegate ?? self
      ad.paidEventHandler = paidEventHandler
    case .appOpen(let ad):
      ad.present(fromRootViewController: presenter)
      ad.fullScreenContentDelegate = fullScreenContentDelegate ?? self
      ad.paidEventHandler = paidEventHandler
    case .rewarded(let ad):
      ad.present(
        fromRootViewController: presenter, userDidEarnRewardHandler: userDidEarnRewardHandler ?? {})
      ad.fullScreenContentDelegate = fullScreenContentDelegate ?? self
      ad.paidEventHandler = paidEventHandler
    case .rewardedInterstitial(let ad):
      ad.present(
        fromRootViewController: presenter, userDidEarnRewardHandler: userDidEarnRewardHandler ?? {})
      ad.fullScreenContentDelegate = fullScreenContentDelegate ?? self
      ad.paidEventHandler = paidEventHandler
    case .none:
      break
    }

    self.checkAdCount(format: format, unitId: unitId)

    cacheAd()
  }

  // MARK: - Private Methods

  @objc private func cacheAd() {
    configuration.forEach { item in
      let existingCount = cachedAds.getCount(unitId: item.unitId)

      if existingCount < item.numOfAds {
        let neededCount = item.numOfAds - existingCount

        switch item.format {
        case .interstitial:
          requestAd(
            unitId: item.unitId, numOfAds: neededCount,
            format: .interstitial,
            adLoader: {
              GADInterstitialAd.load(withAdUnitID: item.unitId, request: $0, completionHandler: $1)
            })
        case .rewarded:
          requestAd(
            unitId: item.unitId, numOfAds: neededCount,
            format: .rewarded,
            adLoader: {
              GADRewardedAd.load(withAdUnitID: item.unitId, request: $0, completionHandler: $1)
            })
        case .rewardedInterstitial:
          requestAd(
            unitId: item.unitId, numOfAds: neededCount,
            format: .rewardedInterstitial,
            adLoader: {
              GADRewardedInterstitialAd.load(
                withAdUnitID: item.unitId, request: $0, completionHandler: $1)
            })
        case .appOpen:
          requestAd(
            unitId: item.unitId, numOfAds: neededCount,
            format: .appOpen,
            adLoader: {
              GADAppOpenAd.load(withAdUnitID: item.unitId, request: $0, completionHandler: $1)
            })
        }
      }
    }

    cachedAds.removeExpiredAds()
  }

  private func checkAdCount(format: AdFormat, unitId: String) {
    let count = cachedAds.getCount(unitId: unitId)

    if count == 1 {
      onAvailable?(format, unitId)
    } else if count == 0 {
      onExhausted?(format, unitId)
    }
  }

  private func getPresenter() -> UIViewController? {
    if #available(iOS 15.0, *) {
      if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
        let rootViewController = windowScene.windows.first?.rootViewController
      {
        return rootViewController
      }
    } else {
      if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
        return rootViewController
      }
    }
    return nil
  }

  private func requestAd<T>(
    unitId: String, numOfAds: Int, format: AdFormat,
    adLoader: @escaping (GADRequest, @escaping (T?, Error?) -> Void) -> Void,
    completion: (() -> Void)? = nil
  ) {
    for _ in 1...numOfAds {
      adLoader(GADRequest()) { (ad: T?, error: Error?) in
        if let error = error {
          print("Failed to load \(format.rawValue) ad with error: \(error.localizedDescription)")
          completion?()
          return
        }

        guard let ad = ad else { return }

        guard let adType = self.getAdType(ad) else { return }

        let expirationTime = format == .appOpen ? 4 * 60 * 60 : 60 * 60
        let timestamp = Date()
        let expirationDate = timestamp.addingTimeInterval(TimeInterval(expirationTime))
        let loadedAd = Ad(format: format, unitId: unitId, ad: adType, timestamp: expirationDate)

        self.cachedAds.enqueue(loadedAd)
        self.checkAdCount(format: format, unitId: unitId)
      }
    }
  }

  private func getAdType(_ ad: Any) -> AdType? {
    switch ad {
    case is GADInterstitialAd:
      return .interstitial(ad as! GADInterstitialAd)
    case is GADRewardedAd:
      return .rewarded(ad as! GADRewardedAd)
    case is GADRewardedInterstitialAd:
      return .rewardedInterstitial(ad as! GADRewardedInterstitialAd)
    case is GADAppOpenAd:
      return .appOpen(ad as! GADAppOpenAd)
    default:
      return nil
    }
  }
}

// MARK: - GADFullScreenContentDelegate Extension

extension AdCacher: GADFullScreenContentDelegate {
  public func ad(
    _ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error
  ) {
    onFullScreenContent?(.didFailToPresentFullScreenContentWithError, ad, error)
  }

  public func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    onFullScreenContent?(.adWillPresentFullScreenContent, ad, nil)
  }

  public func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    onFullScreenContent?(.adWillDismissFullScreenContent, ad, nil)
  }

  public func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
    onFullScreenContent?(.adDidRecordClick, ad, nil)
  }

  public func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
    onFullScreenContent?(.adDidRecordImpression, ad, nil)
  }

  public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    onFullScreenContent?(.adDidDismissFullScreenContent, ad, nil)
  }
}
