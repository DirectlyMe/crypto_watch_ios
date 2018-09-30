// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "crypto_watch",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .Package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", majorVersion: 3, minor: 1)
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "crypto_watch",
            dependencies: []),
        .testTarget(
            name: "crypto_watchTests",
            dependencies: ["crypto_watch"]),
    ]
)
