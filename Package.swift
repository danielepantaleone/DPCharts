// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DPCharts",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "DPCharts",
            targets: ["DPCharts"]),
    ],
    targets: [
        .target(
            name: "DPCharts",
            dependencies: [],
            resources: [.copy("PrivacyInfo.xcprivacy")]),
    ]
)
