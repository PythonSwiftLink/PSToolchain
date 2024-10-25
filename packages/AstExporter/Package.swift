// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AstExporter",
	platforms: [
		.macOS(.v11)
	],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AstExporter",
            targets: ["AstExporter"]),
    ],
	dependencies: [
		.package(url: "https://github.com/PythonSwiftLink/PyAst", from: "0.0.7"),
		.package(url: "https://github.com/kylef/PathKit", .upToNextMajor(from: "1.0.1")),
	],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AstExporter"),
        .testTarget(
            name: "AstExporterTests",
            dependencies: ["AstExporter"]),
    ]
)
