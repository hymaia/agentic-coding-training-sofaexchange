// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "SofaExchange",
    platforms: [.iOS(.v16)],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.9.0"),
    ],
    targets: [
        .target(
            name: "SofaExchange",
            dependencies: ["Alamofire"],
            path: "SofaExchange"
        ),
        .testTarget(
            name: "SofaExchangeTests",
            dependencies: ["SofaExchange"],
            path: "SofaExchangeTests"
        ),
    ]
)
