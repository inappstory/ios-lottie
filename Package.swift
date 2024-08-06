// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IASLottie",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "IASLottie", targets: ["IASLottie"])
    ],
    targets: [
        .binaryTarget(
            name: "IASLottie",
            path: "IASLottie.xcframework"
        )
    ],
    swiftLanguageVersions: [.v5]
)
