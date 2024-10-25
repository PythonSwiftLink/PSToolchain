
import Foundation
import PyAst
import PySwiftCore
import PythonCore
import PyEncode
import PyCallable



extension AST.List: PyEncodable {
	static let PyList = pythonImport(from: "ast", import_name: "List")!
	public var pyPointer: PyPointer {
		let py_list: PyPointer = try! Self.PyList(
			elts.pyList
		)
		
		return py_list
	}
}


