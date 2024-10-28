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

		.package(url: "https://github.com/PythonSwiftLink/Swiftonize.git", from: .init(0, 0, 2)),
		// temporary
		//.package(path: "/Volumes/CodeSSD/GitHub/Swiftonize"),
		//.package(path: "/Volumes/CodeSSD/PSL-development/PyAst"),
		.package(path: "../packages/PSProjectGenerator"),
		//.package(path: "../packages/PythonFiles"),
		.package(path: "../packages/FakePip"),
		.package(path: "../packages/AstExporter")
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
				.product(name: "PyDictionary", package: "PythonSwiftLink"),
				.product(name: "SwiftonizeNew", package: "Swiftonize"),
				.product(name: "SwiftPackage", package: "SwiftPackageGen"),
				.product(name: "GeneratePackage", package: "SwiftPackageGen"),
				
				.product(name: "PSProjectGen", package: "PSProjectGenerator"),
				.product(name: "FakePip", package: "FakePip"),
				//.product(name: "PythonFiles", package: "PythonFiles"),
				.product(name: "AstExporter", package: "AstExporter")
            ]
        ),
    ]
)
