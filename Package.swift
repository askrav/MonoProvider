// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "MonoProvider",
    products: [
        .library(name: "MonoProvider", targets: ["MonoProvider"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
    ],
    targets: [
        .target(name: "MonoProvider", dependencies: ["Vapor"]),
        .testTarget(name: "MonoProviderTests", dependencies: ["Vapor", "MonoProvider"]),
    ]
)
