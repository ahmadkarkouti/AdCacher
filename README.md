# AdCacher

`AdCacher` is a Swift library for iOS that provides a convenient way to cache and present ads using Google Mobile Ads SDK. It supports various ad formats, including interstitial, rewarded, rewarded interstitial, and app open ads.

## Installation

### CocoaPods

To integrate `AdCacher` into your Xcode project using CocoaPods, add the following line to your `Podfile`:

```ruby 
pod 'AdCacher', :git => 'https://github.com/ahmadkarkouti/AdCacher.git'
```

Then run:

```ruby
pod install
```

## Usage

1. Configuration
First, configure the `AdCacher` with your ad configurations and set an interval for ad requests:
```ruby
AdCacher.shared.configure(
    configs: [AdConfiguration(format: .interstitial, unitId: self.adUnitId, numOfAds: 1)],
    interval: 10
)
```
2. Handling Ad Availability and Exhaustion
You can handle ad availability and exhaustion using the following callbacks:
```ruby
AdCacher.shared.onAvailable = { format, unitId in
    print("Available")
}

AdCacher.shared.onExhausted = { format, unitId in
    print("Unavailable")
}
```
3. Handling Full-Screen Content Events
You can handle full-screen content events either by setting the delegate when showing the ad or by accessing the `onFullScreenContent` callback:
```ruby
AdCacher.shared.onFullScreenContent = { contentType, theAd, error in
    // Handle full-screen content events here
}
```
To set the delegate when showing the ad:
```ruby
AdCacher.shared.showAd(
    forFormat: .interstitial, 
    unitId: self.adUnitId, 
    paidEventHandler: { paidEvent in
        // Handle paid events here
    },
    fullScreenContentDelegate: self // Ensure your class conforms to GADFullScreenContentDelegate
)
```
4. Full-Screen Content Delegate
Implement the `GADFullScreenContentDelegate` to receive full-screen content events:
```ruby
extension YourViewController: GADFullScreenContentDelegate {
    public func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        // Handle the failure to present full-screen content
    }

    public func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        // Handle the event when full-screen content is about to be presented
    }

    public func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        // Handle the event when full-screen content is about to be dismissed
    }

    public func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        // Handle the event when the user clicks on the full-screen content
    }

    public func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        // Handle the event when the full-screen content records an impression
    }

    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        // Handle the event when full-screen content is dismissed
    }
}
```

## API Documentation
### AdCacher
* `public static let shared: AdCacher`
Singleton instance of `AdCacher`.

* `public func configure(configs: [AdConfiguration], interval: Double)`

Configures the ad caching with given configurations and interval.

* `public func endCacher()`

Stops the ad caching timer.

* `public func showAd(forFormat format: AdFormat, unitId: String, paidEventHandler: GADPaidEventHandler?, fullScreenContentDelegate: GADFullScreenContentDelegate?, userDidEarnRewardHandler: (() -> Void)?)`

Presents a full-screen ad.

* `public var onAvailable: ((_ format: AdFormat, _ unitId: String) -> Void)?`

Callback when an ad becomes available.

* `public var onExhausted: ((_ format: AdFormat, _ unitId: String) -> Void)?`

Callback when an ad is exhausted.

* `public var onFullScreenContent: ((FullScreenContentType, GADFullScreenPresentingAd, Error?) -> Void)?`

Callback for full-screen content events.

### AdConfiguration
* `public let format: AdFormat`
* `public let unitId: String`
* `public let numOfAds: Int`


### AdFormat
* `case interstitial`
* `case rewarded`
* `case rewardedInterstitial`
* `case appOpen`

### AdType
* `case interstitial(GADInterstitialAd)`
* `case rewarded(GADRewardedAd)`
* `case rewardedInterstitial(GADRewardedInterstitialAd)`
* `case appOpen(GADAppOpenAd)`

### FullScreenContentType
* `case didFailToPresentFullScreenContentWithError`
* `case adWillPresentFullScreenContent`
* `case adWillDismissFullScreenContent`
* `case adDidRecordClick`
* `case adDidRecordImpression`
* `case adDidDismissFullScreenContent`

### AdQueue
* `mutating func enqueue(_ ad: Ad)`
* `mutating func dequeue(unitId: String) -> Ad?`
* `var isEmpty: Bool`
* `func getCount(unitId: String) -> Int`
* `mutating func removeExpiredAds()`

## License
This library is released under the MIT [License](https://github.com/ahmadkarkouti/AdCacher/blob/main/LICENSE). See the LICENSE file for details.
