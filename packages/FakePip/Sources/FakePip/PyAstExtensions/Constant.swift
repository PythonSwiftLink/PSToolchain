
import Foundation
import PyAst
import PySwiftCore
import PythonCore
import PyEncode
import PyCallable



extension AST.Constant: PyEncodable {
	static let PyConstant = pythonImport(from: "ast", import_name: "Constant")!
	public var pyPointer: PyPointer {
		let py_const: PyPointer = try! Self.PyConstant(
			value
		)
		
		return py_const
	}
}


