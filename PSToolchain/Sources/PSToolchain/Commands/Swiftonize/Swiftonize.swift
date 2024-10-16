

import Foundation
import ArgumentParser
import Swiftonizer
import PyWrapper
import PathKit


extension PSToolchain {
	
	struct Swiftonize: AsyncParsableCommand {
		
		static var configuration: CommandConfiguration = .init(
			subcommands: [
				Build.self
			]
		)
		
		struct Build: AsyncParsableCommand {
			
			@Argument var source: Path
			@Argument var destination: Path
			@Option var site: Path?
			
			
			func run() async throws {
				try launchPython()
				let wrappers = try SourceFilter(root: source)
				
				for file in wrappers.sources {
					
					switch file {
					case .pyi(let path):
						try await build_wrapper(src: path, dst: file.swiftFile(destination), site: site)
					case .py(let path):
						try await build_wrapper(src: path, dst: file.swiftFile(destination), site: site)
					case .both(_, let pyi):
						try await build_wrapper(src: pyi, dst: file.swiftFile(destination), site: site)
					}
				}
			}
		}
		
	}
	
}

func build_wrapper(src: Path, dst: Path, site: Path?, beeware: Bool = true) async throws {
	
	let filename = src.lastComponentWithoutExtension
	let code = try src.read(.utf8)
	let module = try PyWrap.parse(filename: filename,string: code)
	let module_code = try module.file().formatted().description

	try dst.write(module_code)
	
}
