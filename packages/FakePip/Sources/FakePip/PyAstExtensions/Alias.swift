
import Foundation
import PyAst
import PySwiftCore
import PythonCore
import PyEncode
import PyCallable



extension AST.Alias: PyEncodable {
	static let PyAlias = pythonImport(from: "ast", import_name: "alias")!
	public var pyPointer: PyPointer {
		let py_alias: PyPointer = try! Self.PyAlias(
			name
		)
		
		return py_alias
	}
}

//extension AST.Alias: ExpressibleByStringLiteral {
//	public init(stringLiteral value: StringLiteralType) {
//		name = value
//		asname = nil
//		lineno = 0
//		col_offset = 0
//		end_lineno = nil
//		end_col_offset = nil
//		type_comment = nil
//	}
//}
