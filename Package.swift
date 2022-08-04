// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "GraphQL",

    products: [
        .library(name: "GraphQL", targets: ["GraphQL"]),
    ],

    dependencies: [
        .package(url: "https://github.com/wickwirew/Runtime.git", .upToNextMinor(from: "2.2.0")),

        // ⏱ Promises and reactive-streams in Swift built for high-performance and scalability.
//        .package(url: "https://github.com/apple/swift-nio.git", .upToNextMajor(from: "1.14.1"))
        .package(url: "https://github.com/apple/swift-nio.git", .upToNextMajor(from: "2.10.1"))
    ],

    targets: [
        .target(name: "GraphQL", dependencies: ["Runtime", "NIO"]),
        .testTarget(name: "GraphQLTests", dependencies: ["GraphQL"]),
    ]
)
