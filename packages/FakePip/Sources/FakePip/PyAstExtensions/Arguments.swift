
import Foundation
import PyAst
import PySwiftCore
import PythonCore
import PyEncode
import PyCallable

extension AST.Arg: PyEncodable {
	static let PyArg = pythonImport(from: "ast", import_name: "arg")!
	
	public var pyPointer: PyPointer {
		if let annotation = annotation {
			return try! Self.PyArg(
				arg,
				Expr2PyPointer(annotation)!
			)
		}
		return try! Self.PyArg(
			arg
		)
	}
}

fileprivate func handle_args(_ args: [AST.Arg]) -> [AST.Arg] {
	args.compactMap { arg in
		if arg.arg == "self" {
			return AST.Arg(label: "self")
		}
		return arg
	}
}

extension AST.Arguments: PyEncodable {
	static let PyArguments = pythonImport(from: "ast", import_name: "arguments")!
	public var pyPointer: PyPointer {
		let empty_list = PyList_New(0)!
		let py_cls: PyPointer = try! Self.PyArguments(
			empty_list,
			handle_args(args),
			PyNone,
			empty_list,
			PyNone,
			PyNone,
			empty_list
		)
		
		return py_cls
	}
}


