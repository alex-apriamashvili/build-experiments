// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MockLib2",
    products: [
        .library(
            name: "MockLib2",
            targets: ["MockLib2"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MockLib2",
            dependencies: []),
    ]
)
