
import Foundation
import PyAst
import PySwiftCore
import PythonCore
import PyEncode
import PyCallable



extension AST.Call: PyEncodable {
	static let PyCall = pythonImport(from: "ast", import_name: "Call")!
	public var pyPointer: PyPointer {
		let py_call: PyPointer = try! Self.PyCall(
			Expr2PyPointer(_func),
			args.pyList,
			keywords
		)
		
		return py_call
	}
}


