

import Foundation
import ArgumentParser
import Swiftonizer
import PyWrapper
import PathKit
import FakePip
import PythonFiles
import PySwiftCore
import PyDictionary


extension PSToolchain.Swiftonize {
	struct VenvDump: AsyncParsableCommand {
		static let decompile = pythonImport(from: "ast_decompiler", import_name: "decompile")!
		static let str = PyDict_GetItem(pyBuiltins!, "str")
		
		@Argument var source: Path
		@Argument var destination: Path
		
		func run() async throws {
			try PSToolchain.launchPython()
			let wrappers = try SourceFilter(root: source)
			
			for file in wrappers.sources {
				
				switch file {
				case .pyi(let path):
					let output: String = try Self.decompile(
						venv_dump(wrapper: path)
					)
					try (destination + path.lastComponent).write(output, encoding: .utf8)
				case .py(let path):
					let output: String = try Self.decompile(
						venv_dump(wrapper: path)
					)
					try (destination + path.lastComponent).write(output, encoding: .utf8)
				case .both(_, let pyi):
					let output: String = try Self.decompile(
						venv_dump(wrapper: pyi)
					)
					try (destination + pyi.lastComponent).write(output, encoding: .utf8)
				}
				
				
			}
		}
	}
}
