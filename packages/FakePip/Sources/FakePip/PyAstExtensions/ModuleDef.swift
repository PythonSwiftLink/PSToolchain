
import Foundation
import PyAst
import PySwiftCore
import PythonCore
import PyEncode
import PyCallable
import PyExpressible


extension AST.Module: PyEncodable {
	static let PyModuleDef = pythonImport(from: "ast", import_name: "ModuleDef")!
	public var pyPointer: PyPointer {
		var py_body: [PyPointer] = []
		
		return try! Self.PyModuleDef(
			body.pyList
		)
		
	}
}

extension AST.Assign {
	static func TypeVar(typevar: String, type: String? = nil) -> Self {
		AST.Assign(
			targets: [AST.Name(id: typevar)],
			value: AST.Call(
				_func: AST.Name(id: "NewType"),
				args: [
					AST.Constant(stringLiteral: typevar),
					AST.Name(id: type ?? "object")
				],
				keywords: []
			),
			lineno: 0,
			col_offset: 0
		)
	}
}

extension AstExportModule: PyEncodable {
	static let PyModule = pythonImport(from: "ast", import_name: "Module")!
	static let fix_missing_locations = pythonImport(from: "ast", import_name: "fix_missing_locations")!
	public var pyPointer: PyPointer {
		var py_body: [PyPointer] = [
			//"from typing import Protocol, NewType, TypedDict, Callable\n"
			AST.ImportFrom(
				module: "typing",
				names: [
					"Protocol",
					"NewType",
					"TypedDict",
					"Callable",
					"Optional"
				],
				level: 0,
				lineno: 0,
				col_offset: 0
			).pyPointer
		]
//		var call_once = AST.ClassDef(
//			name: "CallableOnce",
//			bases: [AST.Name(id: "Callable")],
//			keywords: [],
//			body: [AST.Expr(value: AST.Constant(stringLiteral: "CallableOnce requires strong ref"))],
//			decorator_list: [],
//			lineno: 0,
//			col_offset: 0
//		)
//		py_body.append(call_once.pyPointer)
		
//		py_body.append(AST.Assign.TypeVar(typevar: "CallableOnce", type: "Callable").pyPointer)
//		py_body.append(
//			AST.Assign(
//				targets: [AST.Attribute(value: AST.Name(id: "CallableOnce"), attr: "__doc__", description: "")],
//				value: AST.Constant(stringLiteral: "CallableOnce requires strong ref")
//			).pyPointer
//		)
//		for type_var in ["Error", "URL"] {
//			py_body.append(AST.Assign.TypeVar(typevar: type_var, type: "str").pyPointer)
//		}
//		py_body.append(AST.Assign.TypeVar(typevar: "data", type: "bytes").pyPointer)
		for typevar in type_vars {
			//py_body.append("\(typevar) = NewType(\"\(typevar)\", object)".pyPointer)
			py_body.append(
				AST.Assign.TypeVar(typevar: typevar).pyPointer
			)
		}
		
		py_body.append(contentsOf: body.pyArray)
		
		let m: PyPointer = try! Self.PyModule(
			py_body
		)
		return try! Self.fix_missing_locations(m)
	}
}
