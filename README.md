# IASLottie

Library Connector, for connecting Lottie animations to games

| IASLottie version | Build version | iOS version |
| ----------------- | ------------- | ----------- |
| 0.2.2             | 91            | >= 13.0     |

Version 0.2.2 migrates the standalone Xcode project's Lottie dependency from CocoaPods to Swift Package Manager, using the official dynamic Lottie 4.6.1 package (`airbnb/lottie-spm`). The host application embeds `Lottie.framework` separately; IASLottie links to it without including Lottie's implementation. The animation API and playback code are unchanged.

The migration prepares for [CocoaPods Trunk becoming read-only](https://blog.cocoapods.org/CocoaPods-Specs-Repo/), currently scheduled for December 2, 2026. Trunk will no longer accept new pods or version publications; existing published versions will remain available. The podspec is retained for compatibility with existing Git-based integrations.

The public source `Package.swift` dependency range remains 4.4.1 up to, but excluding, 5.0.0. IASLottie requires iOS 13 or later and is built from source alongside Lottie. Building with Lottie 4.6.1 requires Xcode 16 / Swift 6.0 or later.

Version of the library can be obtained from the parameter `IASLottieVersion`

All documentation with code samples has been moved to [docs.inappstory.com](https://docs.inappstory.com/sdk-guides/ios/lottie-animation.html)
