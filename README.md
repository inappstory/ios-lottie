# IASLottie

Library Connector, for connecting Lottie animations to games

| IASLottie version | Build version | iOS version |
| ----------------- | ------------- | ----------- |
| 0.2.1             | 90            | >= 13.0     |

Version 0.2.1 fixes the Swift Package Manager deployment-target conflict when using Lottie 4.6.1. IASLottie requires iOS 13 or later; its animation API and playback code are unchanged.

The existing Lottie dependency remains unchanged: Swift Package Manager accepts versions from 4.4.1 up to, but excluding, 5.0.0. IASLottie is built from source alongside Lottie. Building with Lottie 4.6.1 requires Xcode 16 / Swift 6.0 or later.

Version of the library can be obtained from the parameter `IASLottieVersion`

All documentation with code samples has been moved to [docs.inappstory.com](https://docs.inappstory.com/sdk-guides/ios/lottie-animation.html)
