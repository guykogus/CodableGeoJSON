// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "CodableGeoJSON",
    products: [
        .library(
            name: "CodableGeoJSON",
            targets: ["CodableGeoJSON"]),
    ],
    dependencies: [
        .package(url: "https://github.com/guykogus/CodableJSON.git", from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "CodableGeoJSON",
            dependencies: ["CodableJSON"],
            path: "CodableGeoJSON",
            swiftSettings: [
                .enableUpcomingFeature("ConciseMagicFile"),
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("ForwardTrailingClosures"),
            ]
        ),
        .testTarget(
            name: "CodableGeoJSONTests",
            dependencies: ["CodableGeoJSON"],
            path: "CodableGeoJSONTests",
            swiftSettings: [
                .enableUpcomingFeature("ConciseMagicFile"),
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("ForwardTrailingClosures"),
            ]
        ),
    ]
)
