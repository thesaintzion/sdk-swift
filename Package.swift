// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DojahWidget",
    platforms: [.iOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "DojahWidget", targets: ["DojahWidget"]),
    ],
    dependencies: [
        .package(url: "https://github.com/airbnb/HorizonCalendar.git", from: "1.0.0"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.3.3"),
        .package(url: "https://github.com/realm/realm-swift.git", from: "10.44.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DojahWidget",
            dependencies: [
                "HorizonCalendar", 
                .product(name: "Lottie", package: "lottie-ios"),
                .product(name: "Realm", package: "realm-swift"),
                .product(name: "RealmSwift", package: "realm-swift")
            ],
            resources: [
                .copy("Resources/countries.json"),
                .copy("Resources/Animations/loading-circle.json"),
                .copy("Resources/Animations/cancel.json"),
                .copy("Resources/Animations/warning.json"),
                .copy("Resources/Animations/error-2.json"),
                .copy("Resources/Animations/failed.json"),
                .copy("Resources/Animations/check-2.json"),
                .copy("Resources/Animations/success.json"),
                .copy("Resources/Animations/successfully-done.json"),
                .copy("Resources/Animations/error.json"),
                .copy("Resources/Animations/circle-loader.json"),
                .copy("Resources/Animations/successfully-done-2.json"),
                .copy("Resources/Animations/successfully-send.json")
            ]
        ),
        .testTarget(name: "DojahWidgetTests", dependencies: ["DojahWidget"]),
    ]
)
