

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
			
			
			
			func run() async throws {
				try launchPython()
				
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
