// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ATVersionControl-iOS",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(
            name: "ATVersionControl-iOS",
            targets: ["ATVersionControl-iOS"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/mohabbasi1213/SwiftBooster.git", .branch("main")),
        .package(url: "https://github.com/Orderella/PopupDialog.git", .branch("main")),
        .package(url: "https://github.com/mohabbasi1213/AyanTechNetworkingLibrary-iOS.git", .branch("main")),
    ],
    targets: [
        .target(
            name: "ATVersionControl-iOS", path: "ATVersionControl"),
    ]
)
