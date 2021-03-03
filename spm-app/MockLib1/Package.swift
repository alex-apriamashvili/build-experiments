// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MockLib1",
    products: [
        .library(
            name: "MockLib1",
            targets: ["MockLib1"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MockLib1",
            dependencies: []),
    ]
)
