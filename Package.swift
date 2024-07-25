// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AyanTechNetworkingLibrary",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(
            name: "AyanTechNetworkingLibrary",
            targets: ["ATNetworking"]
        ),
    ],
    targets: [
        .target(
            name: "ATNetworking",
            path: "AyanTechNetworkingLibrary"
        ),
    ]
)


