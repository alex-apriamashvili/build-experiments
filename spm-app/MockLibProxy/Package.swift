// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MockLibProxy",
    products: [
        .library(
            name: "MockLibProxy",
            type: .dynamic,
            targets: ["MockLibProxy"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "MockLibProxy",
          dependencies: []),
    ]
)
