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
