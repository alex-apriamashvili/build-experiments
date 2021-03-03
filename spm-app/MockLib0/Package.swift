// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MockLib0",
    products: [
        .library(
            name: "MockLib0",
            targets: ["MockLib0"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MockLib0",
            dependencies: []),
    ]
)
