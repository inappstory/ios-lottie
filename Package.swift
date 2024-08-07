// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IASLottie",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "IASLottie",
            targets: ["IASLottie"]
        ),
    ],
    dependencies: [
        .package(name: "Lottie", url: "https://github.com/airbnb/lottie-ios.git", from: "4.4.1"),
    ],
    targets: [
        .target(
            name: "IASLottie",
            dependencies: ["Lottie"],
            path: "Sources",
            publicHeadersPath: "include"
        )
    ]
)
