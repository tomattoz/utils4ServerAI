// swift-tools-version:5.9.2

import PackageDescription

let package = Package(
    name: "Utils9AIServer",
    defaultLocalization: "en",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(name: "Utils9AIServer", targets: ["Utils9AIServer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", branch: "main"),
        .package(url: "https://github.com/tomattoz/openai-kit.git", branch: "main"),
        .package(url: "https://github.com/tomattoz/utils", branch: "master"),
        .package(url: "https://github.com/tomattoz/utils4AdapterAI", branch: "master"),
        .package(url: "https://github.com/tomattoz/utils4FirestoreAI", branch: "master"),
    ],
    targets: [
        .target(name: "Utils9AIServer",
                dependencies: [
                    .product(name: "Vapor", package: "vapor"),
                    .product(name: "OpenAIKit", package: "openai-kit"),
                    .product(name: "Utils9", package: "utils"),
                    .product(name: "Utils9AIAdapter", package: "utils4AdapterAI"),
                    .product(name: "Utils9AIFirestore", package: "utils4FirestoreAI"),
                ],
                path: "Sources")
    ]
)
