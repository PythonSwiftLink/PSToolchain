
import Foundation
import PyAst
import PySwiftCore
import PythonCore
import PyEncode
import PyCallable



extension AST.ImportFrom: PyEncodable {
	static let PyImportFrom = pythonImport(from: "ast", import_name: "ImportFrom")!
	public var pyPointer: PyPointer {
		let py_import: PyPointer = try! Self.PyImportFrom(
			module,
			names
		)
		
		return py_import
	}
}


