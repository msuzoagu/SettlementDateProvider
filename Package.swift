// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SettlementDateProvider",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "SettlementDateProvider",
            targets: ["SettlementDateProvider"]
        ),
    ],
    targets: [
        .target(
            name: "SettlementDateProvider",
            resources: [
                .process("Resources"),
            ]
        ),
        .testTarget(
            name: "SettlementDateProviderTests",
            dependencies: ["SettlementDateProvider"],
            resources: [
                .process("Resources/US.json"),
            ],
            swiftSettings: [
                .define("TESTING"),
            ]
        ),
    ]
)
