//
//  File.swift
//  
//
//  Created by CodeBuilder on 13/10/2024.
//

import Foundation
import ArgumentParser
import PSProjectGen
import PathKit

extension PSToolchain.Project {
	struct Kivy: AsyncParsableCommand {
		static var configuration: CommandConfiguration = .init(
			subcommands: [
				Create.self
			]
		)
	}
	
}


extension PSToolchain.Project.Kivy {
	struct Create: AsyncParsableCommand {
		@Argument var name: String
		
		@Option(name: .short) var python_src: Path?
		
		@Option(name: .short) var requirements: Path?
		
		@Option(name: .short) var spec: Path?
		
		@Flag(name: .short) var forced: Bool = false
		
		func run() async throws {
			//			try await GithubAPI(owner: "PythonSwiftLink", repo: "KivyCore").handleReleases()
			//			return
			let projDir = (Path.current + name)
			if forced, projDir.exists {
				try? projDir.delete()
			}
			try? projDir.mkdir()
			//chdir(projDir.string)
			//let projectSpec: Path? = if let swift_packages = swift_packages {.init(swift_packages)} else { nil }
			let proj = try await KivyProject(
				name: name,
				py_src: python_src,
				requirements: requirements,
				//projectSpec: swift_packages == nil ? nil : .init(swift_packages!),
				projectSpec: spec,
				workingDir: projDir
			)
			
			try await proj.createStructure()
			try await proj.generate()
			
			
		}
		
	}
}

extension PSToolchain.Project.Kivy {
	struct GenerateSpec: AsyncParsableCommand {
		
		@Option(name: .short) var path: Path?
		
		func run() async throws {
			let specPath = path ?? (Path.current + "projectSpec.yml")
			if specPath.exists { throw CocoaError(.fileWriteFileExists) }
			try specPath.write(newSpecData())
		}
	}
}

extension PSToolchain.Project.Kivy {
	struct Patch: AsyncParsableCommand {
		
		@Option(name: .short) var project_path: String
		
		func run() async throws {
			let workingDir: Path = .init(project_path)
			let resources = workingDir + "Resources"
			var mainSiteFolder: Path { resources + "site-packages" }
			var distFolder: Path { workingDir + "dist_lib"}
			
			var site_folders: [Path] {
				
				var output: [Path] = [ mainSiteFolder ]
				let numpySite = resources + "numpy-site"
				if numpySite.exists {
					output.append(numpySite)
				}
				
				return output
			}
			for site_folder in site_folders {
				try patchPythonLib(pythonLib: site_folder, dist: distFolder)
			}
		}
	}
}
