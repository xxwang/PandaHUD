// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PandaHUD",
    platforms: [
        .iOS(.v13),
        .macOS(.v12),
        .tvOS(.v12),
        .watchOS(.v5),
    ],
    products: [
        .library(name: "PandaHUD", targets: ["PandaHUD"]),
    ],
    dependencies: [
        .package(url: "https://github.com/xxwang/Panda.git", branch: "develop"),
    ],
    targets: [
        .target(name: "PandaHUD", dependencies: ["Panda"], path: "Sources"),
    ]
)
