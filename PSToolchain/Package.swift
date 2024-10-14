// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PSToolchain",
	platforms: [
		.macOS(.v13)
	],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
		.package(path: "../packages/SwiftPackageGen"),
		.package(url: "https://github.com/kylef/PathKit", .upToNextMajor(from: "1.0.1")),
		.package(url: "https://github.com/PythonSwiftLink/PythonSwiftLink", branch: "master"),
		
		// temporary
		.package(path: "/Volumes/CodeSSD/GitHub/Swiftonize"),
		.package(path: "../packages/PSProjectGenerator")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "PSToolchain",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
				.product(name: "PathKit", package: "PathKit"),
				.product(name: "PySwiftCore", package: "PythonSwiftLink"),
				.product(name: "PySwiftObject", package: "PythonSwiftLink"),
				.product(name: "SwiftonizeNew", package: "Swiftonize"),
				.product(name: "SwiftPackage", package: "SwiftPackageGen"),
				.product(name: "GeneratePackage", package: "SwiftPackageGen"),
				
				.product(name: "PSProjectGen", package: "PSProjectGenerator")
            ]
        ),
    ]
)
