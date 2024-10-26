
import Foundation
import PyAst
import PySwiftCore
import PythonCore
import PyEncode
import PyCallable



extension AST.Tuple: PyEncodable {
	static let PyTuple = pythonImport(from: "ast", import_name: "Tuple")!
	public var pyPointer: PyPointer {
		let py_tuple: PyPointer = try! Self.PyTuple(
			elts.pyList
		)
		
		return py_tuple
	}
}


