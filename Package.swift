// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SecuritySignals",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "SecuritySignals",
            targets: ["securitySignalsPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "7.0.0")
    ],
    targets: [
        .target(
            name: "securitySignalsPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/securitySignalsPlugin"),
        .testTarget(
            name: "securitySignalsPluginTests",
            dependencies: ["securitySignalsPlugin"],
            path: "ios/Tests/securitySignalsPluginTests")
    ]
)
