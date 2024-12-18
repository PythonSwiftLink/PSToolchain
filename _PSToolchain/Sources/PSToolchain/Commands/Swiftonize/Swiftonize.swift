import Foundation
import ArgumentParser
import Swiftonizer
import PyWrapper
import PathKit
import FakePip
//import PythonFiles
import PySwiftCore
import PyDictionary

extension PSToolchain {
	
	struct Swiftonize: AsyncParsableCommand {
		
		static var configuration: CommandConfiguration = .init(
			subcommands: [
				Build.self,
				VenvDump.self
			]
		)
	}
}
