
import Foundation
import PyAst
import PySwiftCore
import PythonCore
import PyEncode
import PyCallable



extension AST.Assign: PyEncodable {
	static let PyAssign = pythonImport(from: "ast", import_name: "Assign")!
	public var pyPointer: PyPointer {
		let py_assign: PyPointer = try! Self.PyAssign(
			self.targets.pyList,
			Expr2PyPointer(value)
		)
		
		return py_assign
	}
}


