// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AyanTechNetworkingLibrary",
    platforms: [
        .iOS(.v12),
    ],
    products: [
        .library(
            name: "AyanTechNetworkingLibrary",
            targets: ["AyanTechNetworkingLibrary"]
        ),
    ],
    targets: [
        .target(
            name: "AyanTechNetworkingLibrary", path: "AyanTechNetworkingLibrary"),
    ]
)

