// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Deep",
    products: [
        .library(
            name: "Deep",
            targets: ["Deep"]),
    ],
    targets: [
        .target(
            name: "Deep"),
        .testTarget(
            name: "DeepTests",
            dependencies: ["Deep"]),
    ]
)
