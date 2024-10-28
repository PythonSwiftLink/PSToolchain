
import PyAst


extension AST.Operator.OperatorType {
	var decompiled: String {
		switch self {
			
		case .Add: "+"
		case .BitAnd: "&"
		case .BitOr: "|"
		case .BitXor: "^"
		case .Div: "/"
		case .FloorDiv: "//"
		case .LShift: "<<"
		case .Mod: "%"
		case .Mult: "*"
		case .MatMult: "@"
		case .Pow: "**"
		case .RShift: ">>"
		case .Sub: "-"
		}
	}
	
	var _PRECEDENCE: Int {
		switch self {
			
		case .Add: 8
		case .BitAnd: 6
		case .BitOr: 4
		case .BitXor: 5
		case .Div: 9
		case .FloorDiv: 9
		case .LShift: 7
		case .Mod: 9
		case .Mult: 9
		case .MatMult: 9
		case .Pow: 11
		case .RShift: 7
		case .Sub: 8
		}
	}
}


func _decompile<A>(
	ast: A,
	indentation: Int = 4,
	line_length: Int = 100,
	starting_indentation: Int = 0
) -> String  where A: AstProtocol {
	
	
	
	
	
	fatalError()
}
