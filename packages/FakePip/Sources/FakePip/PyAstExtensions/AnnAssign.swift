
import Foundation
import PyAst
import PySwiftCore
import PythonCore
import PyEncode
import PyCallable



extension AST.AnnAssign: PyEncodable {
	static let PyAnnAssign = pythonImport(from: "ast", import_name: "AnnAssign")!
	public var pyPointer: PyPointer {
		let py_assign: PyPointer = try! Self.PyAnnAssign(
			name.ast_name,
			Expr2PyPointer(annotation),
			PyPointer.None,
			0
			
		)
		
		return py_assign
	}
}


