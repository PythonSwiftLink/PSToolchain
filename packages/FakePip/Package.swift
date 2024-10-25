// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FakePip",
	platforms: [
		.macOS(.v13)
	],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FakePip",
            targets: ["FakePip"]),
    ],
	dependencies: [
		.package(url: "https://github.com/PythonSwiftLink/PyAst", from: .init(0, 0, 0)),
		//.package(path: "/Volumes/CodeSSD/PSL-development/PyAst"),
		.package(url: "https://github.com/PythonSwiftLink/PythonSwiftLink",from: .init(311, 0, 0)),
		.package(url: "https://github.com/PythonSwiftLink/Swiftonize.git", from: .init(0, 0, 0)),
	],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
			name: "FakePip",
			dependencies: [
				.product(name: "PyAst", package: "PyAst"),
				.product(name: "PySwiftCore", package: "PythonSwiftLink"),
				.product(name: "PyEncode", package: "PythonSwiftLink"),
				.product(name: "PyDictionary", package: "PythonSwiftLink"),
				.product(name: "PyCollection", package: "PythonSwiftLink"),
				.product(name: "PyCallable", package: "PythonSwiftLink"),
				.product(name: "PyExpressible", package: "PythonSwiftLink"),
				.product(name: "PyWrapper", package: "Swiftonize")
			]
		),
        .testTarget(
            name: "FakePipTests",
            dependencies: ["FakePip"]),
    ]
)
