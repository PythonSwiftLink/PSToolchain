import Foundation

public let py_modules = Bundle.module.path(forResource: "py_modules", ofType: nil)!

public let ast_decompiler = Bundle.module.path(
	forResource: "ast_decompiler",
	ofType: nil,
	inDirectory: "py_modules"
)!
public let create_pip = Bundle.module.path(
	forResource: "create_pip",
	ofType: "py",
	inDirectory: "py_modules"
)!
public func checkModule() {
	print(ast_decompiler)
	print(create_pip)
}
