
import Foundation
import PyAst
import PySwiftCore
import PythonCore
import PyEncode
import PyCallable



extension AST.BinOp: PyEncodable {
	static let PyBinOp = pythonImport(from: "ast", import_name: "BinOp")!
	public var pyPointer: PyPointer {
		let py_binop: PyPointer = try! Self.PyBinOp(
			Expr2PyPointer(left),
			AST.Operator.BitOr(),
			Expr2PyPointer(right)
			
		)
		
		return py_binop
	}
}


