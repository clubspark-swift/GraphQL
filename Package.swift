// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "GraphQL",

    products: [
        .library(name: "GraphQL", targets: ["GraphQL"]),
    ],

    dependencies: [
        .package(url: "git@github.com:SportlabsTechnology/Runtime.git", .upToNextMinor(from: "2.0.0")),
    ],

    targets: [
        .target(name: "GraphQL", dependencies: ["Runtime"]),

        .testTarget(name: "GraphQLTests", dependencies: ["GraphQL"]),
    ]
)
