
import Foundation
import PyAst
import PySwiftCore
import PythonCore
import PyEncode
import PyCallable



extension AST.Subscript: PyEncodable {
	static let PySubscript = pythonImport(from: "ast", import_name: "Subscript")!
	public var pyPointer: PyPointer {
		let py_sub: PyPointer = try! Self.PySubscript(
			Expr2PyPointer(value),
			Expr2PyPointer(slice)
		)
		
		return py_sub
	}
}


