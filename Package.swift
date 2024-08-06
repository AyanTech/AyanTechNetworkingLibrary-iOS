// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AyanTechNetworkingLibrary-iOS",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(
            name: "AyanTechNetworkingLibrary-iOS",
            targets: ["AyanTechNetworkingLibrary-iOS"]
        ),
    ],
    targets: [
        .target(
            name: "AyanTechNetworkingLibrary-iOS", path: "AyanTechNetworkingLibrary"),
    ]
)