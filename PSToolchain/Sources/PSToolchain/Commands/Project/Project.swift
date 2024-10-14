

import Foundation
import ArgumentParser

extension PSToolchain {
	struct Project: AsyncParsableCommand {
		static var configuration: CommandConfiguration = .init(
			subcommands: [
				Kivy.self,
				Swiftui.self
			]
		)
	}
}






