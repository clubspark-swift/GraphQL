// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "GraphQL",

    products: [
        .library(name: "GraphQL", targets: ["GraphQL"]),
    ],

    dependencies: [
        .package(url: "https://github.com/wickwirew/Runtime.git", .revision("40cdfbad9650512507c060824e1c4e9fc2ca721d")),
    ],

    targets: [
        .target(name: "GraphQL", dependencies: ["Runtime"]),

        .testTarget(name: "GraphQLTests", dependencies: ["GraphQL"]),
    ]
)
