// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "SofaExchange",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    dependencies: [],
    targets: [
        .target(
            name: "SofaExchange",
            dependencies: [],
            path: "SofaExchange",
            exclude: ["Info.plist"]
        ),
        .testTarget(
            name: "SofaExchangeTests",
            dependencies: ["SofaExchange"],
            path: "SofaExchangeTests"
        ),
    ]
)
