// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "UnifiedPowerhouse",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "UnifiedPowerhouse",
            targets: ["UnifiedPowerhouse"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "UnifiedPowerhouse",
            dependencies: [],
            path: "UnifiedPowerhouse"
        )
    ]
)
