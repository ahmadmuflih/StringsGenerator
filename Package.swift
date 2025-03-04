// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StringsGenerator",
    products: [
        // Products can be used to vend plugins, making them visible to other packages.
        .plugin(name: "StringsGeneratorPlugin", targets: ["StringsGeneratorPlugin"]),
        .plugin(name: "EnforceManualExtractionStatePlugin", targets: ["EnforceManualExtractionStatePlugin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .plugin(
            name: "StringsGeneratorPlugin",
            capability: .buildTool(),
            dependencies: [.target(name: "StringsGenerator")]
        ),
        .plugin(
            name: "EnforceManualExtractionStatePlugin",
            capability: .command(
                intent: .custom(
                    verb: "handle-stale-strings",
                    description: "handle-stale-strings"
                ),
                permissions: [
                    .writeToPackageDirectory(reason: "StringsGenerator wants to update the xcstrings to enforce manual extractionState into stale strings")
                ]
            )
        ),
        .executableTarget(
            name: "StringsGenerator",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(name: "StringsGeneratorTests", dependencies: ["StringsGenerator"]),
    ]
)
