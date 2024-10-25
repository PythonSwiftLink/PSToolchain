
import Foundation
import PyAst
import PySwiftCore
import PythonCore
import PyEncode
import PyCallable



extension AST.Name: PyEncodable {
	static let PyName = pythonImport(from: "ast", import_name: "Name")!
	public var pyPointer: PyPointer {
		let py_name: PyPointer = try! Self.PyName(
			id
		)
		
		return py_name
	}
}


