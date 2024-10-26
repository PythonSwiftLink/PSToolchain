
import Foundation
import PyAst
import PySwiftCore
import PythonCore
import PyEncode
import PyCallable



extension AST.FunctionDef: PyEncodable {
	static let PyFunctionDef = pythonImport(from: "ast", import_name: "FunctionDef")!
	public var pyPointer: PyPointer {
		let rtns = Expr2PyPointer(returns) ?? .None
		let py_func: PyPointer = try! Self.PyFunctionDef(
			name,
			args,
			[AST.Name(id: "...\n")],
			decorator_list.pyList,
			rtns
		)
		
		return py_func
	}
}


