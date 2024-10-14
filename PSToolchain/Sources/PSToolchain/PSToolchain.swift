// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import PathKit
import PSProjectGen
@main
struct PSToolchain: AsyncParsableCommand {
	
	static func launchPython() throws {
		let python = PythonHandler.shared
		if !python.defaultRunning {
			python.start(
				stdlib: "/Library/Frameworks/Python.framework/Versions/3.11/lib/python3.11",
				app_packages: [],
				debug: true
			)
		}
	}
	
	static var configuration: CommandConfiguration = .init(
		subcommands: [
			Swiftonize.self,
			Package.self,
			Project.self,
		]
	)
	
}



extension PathKit.Path: ExpressibleByArgument {
	public init?(argument: String) {
		self.init(argument)
	}
}
