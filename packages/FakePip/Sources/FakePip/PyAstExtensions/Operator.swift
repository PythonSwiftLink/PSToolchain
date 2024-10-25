//
//  File.swift
//  
//
//  Created by CodeBuilder on 20/10/2024.
//

import Foundation

import Foundation
import PyAst
import PySwiftCore
import PythonCore
import PyEncode
import PyCallable



extension AST.Operator.BitOr: PyEncodable {
	static let PyBitOr = pythonImport(from: "ast", import_name: "BitOr")!
	public var pyPointer: PyPointer {
		try! Self.PyBitOr()
	}
}


