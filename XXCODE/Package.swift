// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "IslandPlatform",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "IslandPlatform", targets: ["IslandPlatform"]),
        .executable(name: "platform-demo", targets: ["PlatformDemo"])
    ],
    targets: [
        .target(name: "IslandPlatform", path: "Sources/IslandPlatform"),
        .executableTarget(name: "PlatformDemo", dependencies: ["IslandPlatform"], path: "Sources/PlatformDemo"),
        .testTarget(name: "IslandPlatformTests", dependencies: ["IslandPlatform"], path: "Tests")
    ]
)
