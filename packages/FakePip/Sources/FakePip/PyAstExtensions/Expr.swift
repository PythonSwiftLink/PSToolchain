
import Foundation
import PyAst
import PySwiftCore
import PythonCore
import PyEncode
import PyCallable



extension AST.Expr: PyEncodable {
	static let PyExpr = pythonImport(from: "ast", import_name: "Expr")!
	public var pyPointer: PyPointer {
		let py_expr: PyPointer = try! Self.PyExpr(
			Expr2PyPointer(value)
		)
		
		return py_expr
	}
}


