// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "CodableGeoJSON",
    products: [
        .library(
            name: "CodableGeoJSON",
            targets: ["CodableGeoJSON"]),
    ],
    dependencies: [
        .package(url: "https://github.com/guykogus/CodableJSON.git", from: "1.2.0"),
    ],
    targets: [
        .target(
            name: "CodableGeoJSON",
            dependencies: ["CodableJSON"],
            path: "CodableGeoJSON"),
        .testTarget(
            name: "CodableGeoJSONTests",
            dependencies: ["CodableGeoJSON"],
            path: "CodableGeoJSONTests"),
    ]
)
