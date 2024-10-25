
import Foundation
import PyAst
import PySwiftCore
import PythonCore
import PyEncode
import PyCallable



extension AST.Keyword: PyEncodable {
	static let PyKeyword = pythonImport(from: "ast", import_name: "keyword")!
	public var pyPointer: PyPointer {
		let py_kw: PyPointer = try! Self.PyKeyword(
			
		)
		
		return py_kw
	}
}



