
import Foundation
import SwiftPackage
import GeneratePackage
import ArgumentParser
import PathKit




extension PSToolchain {
	struct Package: AsyncParsableCommand {
		
		static var configuration: CommandConfiguration = .init(
			subcommands: [
				Generate.self,
				Update.self
			]
		)
		
	}
}


extension PSToolchain.Package {
	struct Update: AsyncParsableCommand {
		@Argument var file: Path
		@Argument var xcframework: Path
		@Argument var version: String
		@Argument var owner: String
		@Argument var repo: String
		@Option var output: Path?
		@Option var spec: Path?
		
		func run() async throws {
			print("running command")
			let package = try UpdatePackage(
				swiftFile: file,
				xcframeworks: xcframework,
				info: .init(version: version, owner: owner, repo: repo),
				spec: spec
			)
			try await package.modifyPackage()
			let new = package
				.description
			
			if let output = output {
				try output.write(new, encoding: .utf8)
			} else {
				try file.write(new, encoding: .utf8)
			}
		}
	}
	
	struct Generate: AsyncParsableCommand {
		
		@Argument var spec: Path
		@Argument var version: String
		@Option var input: Path?
		@Option var output: Path?
		
		mutating func run() async throws {
			print("swift_file: \(input?.string ?? "no file using internal string")")
			print("spec: \(spec.string)")
			print("version: \(version)")
			
			let package = try await GeneratePackage(fromSwiftFile: input, spec: spec, version: version)
			if let output = output {
				print("--output: \(output.string)")
				try output.write(package.swiftFile.description, encoding: .utf8)
			} else {
				if let input = input {
					try input.write(package.swiftFile.description, encoding: .utf8)
				}
			}
		}
	}
	
}
