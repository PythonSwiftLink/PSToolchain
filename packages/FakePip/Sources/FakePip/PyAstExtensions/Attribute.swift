
import Foundation
import PyAst
import PySwiftCore
import PythonCore
import PyEncode
import PyCallable



extension AST.Attribute: PyEncodable {
	static let PyAttr = pythonImport(from: "ast", import_name: "Attribute")!
	public var pyPointer: PyPointer {
		let py_attr: PyPointer = try! Self.PyAttr(
			Expr2PyPointer(value),
			attr
			
		)
		
		return py_attr
	}
}


