
import Foundation
import PyAst
import PySwiftCore
import PythonCore
import PyEncode
import PyCallable



extension AST.ClassDef: PyEncodable {
	static let PyClassDef = pythonImport(from: "ast", import_name: "ClassDef")!
	public var pyPointer: PyPointer {
		let py_cls: PyPointer = try! Self.PyClassDef(
			name,
			bases.pyList,
			keywords.pyPointer,
			body.pyList,
			decorator_list.pyList
		)
		
		return py_cls
	}
}


