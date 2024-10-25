
import Foundation
import PyAst
import PySwiftCore
import PythonCore
import PyEncode
import PyCallable



extension AST.Pass: PyEncodable {
	static let PyPass = pythonImport(from: "ast", import_name: "Pass")!
	public var pyPointer: PyPointer {
		let py_pass: PyPointer = try! Self.PyPass(
		)
		
		return py_pass
	}
}


