// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import PathKit
import PSProjectGen
//import PythonFiles


@main
struct PSToolchain: AsyncParsableCommand {
	
	static func launchPython() throws {
		let python = PythonHandler.shared
		//try PythonFiles.checkModule()
		if !python.defaultRunning {
			python.start(
				stdlib: "/Library/Frameworks/Python.framework/Versions/3.11/lib/python3.11",
				app_packages: [
					//PythonFiles.py_modules
				],
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

import Foundation

extension PathKit.Path: ExpressibleByArgument {
	public init?(argument: String) {
		self.init(argument)
	}
	
	static let app_path: Self? = {
		guard let _app_path = Foundation.ProcessInfo.processInfo.arguments.first else { return nil }
		var app_path = Path(_app_path)
		
		if app_path.isSymlink {
			app_path = try! app_path.symlinkDestination()
		}
		print(app_path)
		return app_path.parent()
	}()
	
}
