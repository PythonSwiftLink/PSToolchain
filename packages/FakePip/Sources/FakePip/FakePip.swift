import Foundation
import PyAst
import PySwiftCore
import PythonCore
import PathKit
import PyWrapper

extension String {
	var ast_name: AST.Name { .init(id: self) }
	var ast_constant: AST.Constant { .init(stringLiteral: self) }
}

extension Array where Element == any Stmt {
	var pyArray: [PyPointer] {
		lazy.compactMap { stmt -> PyPointer? in
			switch stmt.type {
			case .ClassDef:
				(stmt as? AST.ClassDef)?.pyPointer
			case .FunctionDef:
				(stmt as? AST.FunctionDef)?.pyPointer
			case .AnnAssign:
				(stmt as? AST.AnnAssign)?.pyPointer
			case .Expr:
				(stmt as? AST.Expr)?.pyPointer
			default: fatalError()
			}
		}
	}
	var pyList: PyPointer { pyArray.pyPointer }
}

extension Array where Element == any ExprProtocol {
	var pyArray: [PyPointer] {
		lazy.compactMap(Expr2PyPointer)
	}
	var pyList: PyPointer { pyArray.pyPointer }
}

extension AST.Name {
	func processType() -> Self {
		switch id {
		case "Error", "URL": return .init(id: "str")
		case "data": return .init(id: "bytes")
		default: break
		}
		
		return self
	}
}

extension AST.Constant {
	func processType() -> Self {
		switch value {
		case "Error", "URL": return .init(stringLiteral: "str")
		case "data": return .init(stringLiteral: "bytes")
		default: break
		}
		
		return self
	}
}

func Expr2PyPointer(_ expr: (any ExprProtocol)?) -> PyPointer? {
	switch expr?.type {
	case .none:
		nil
	case .Name:
		(expr as? AST.Name)?.processType().pyPointer
	case .Constant:
		(expr as? AST.Constant)?.processType().pyPointer
	case .Subscript:
		(expr as? AST.Subscript)?.pyPointer
	case .Call:
		(expr as? AST.Call)?.pyPointer
	case .Tuple:
		(expr as? AST.Tuple)?.pyPointer
	case .List:
		(expr as? AST.List)?.pyPointer
	case .BinOp:
		(expr as? AST.BinOp)?.pyPointer
	case .Attribute:
		(expr as? AST.Attribute)?.pyPointer
	default: fatalError()
	}
}


public func venv_dump(wrapper: Path) throws -> PyPointer {
	let module = try PyWrap.parse(file: wrapper.url)
	var type_vars = [AnyArg]()
	var ast_classes: [any Stmt] = module.classes.map(generateAstClass)
	var class_names: [String] = module.classes.map(\.name)
	for cls in module.classes {
		for function in cls.functions ?? [] {
			for arg in function.args {
				if arg.type.py_type == .other {
					
					if !class_names.contains(arg.name), !type_vars.contains(where: {$0.type.string == arg.type.string }) {
						type_vars.append(arg)
					}
				}
			}
		}
		for function in cls.callbacks?.functions ?? [] {
			for arg in function.args {
				if arg.type.py_type == .other {
					
					if !class_names.contains(arg.name), !type_vars.contains(where: {$0.type.string == arg.type.string }) {
						type_vars.append(arg)
					}
				}
			}
		}
	}
	//	let imports: [Stmt] = [
	//		//AST.ImportFrom(module: "", names: <#T##[AST.Alias]#>, level: <#T##Int#>, lineno: <#T##Int#>, col_offset: <#T##Int#>)
	//	]
	var _type_vars = [String]()
	for type_var in type_vars {
		_type_vars.append(type_var.type.string)
	}
	var ast_module = AstExportModule(body: ast_classes, type_vars: _type_vars)
	
	return ast_module.pyPointer
}

import PyCallable
import PyEncode

fileprivate func withGIL<O: PyEncodable>(handle: @escaping ()->O ) -> O {
	let gil = PyGILState_Ensure()
	let result = handle()
	PyGILState_Release(gil)
	return result
}

public class Decompiler {
	
	init() {
		let g = PyDict_New()!
		PyRun_String(
			py_decompiler,
			Py_file_input,
			g,
			g
		)
		module = g
		_decompile = PyDict_GetItemString(module, "decompile")!
	}
	private let module: PyPointer
	private let _decompile: PyPointer
	public static let shared = Decompiler()
//	? = {
//		return PyDict_GetItemString(module, "decompile")!
//	}()
	
	
	public func decompile(ast: PyEncodable) throws -> String {
		try PythonCallWithGil(call: _decompile, ast)
	}
	deinit {
		module.decref()
		_decompile.decref()
	}
}
