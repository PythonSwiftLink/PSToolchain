from ast import *
from typing import TypedDict, Callable
import ast

from astor import to_source
import sys
from json import (
    load as json_load,
    dumps as json_dumps
)

(src, dst) = sys.argv[1:]


def mapper(func: Callable, iter1: list):
    return list(map(func,iter1))

def dict_map(data: dict, **kw):
    key, func = tuple(kw.items())[0]
    #print("dict_map", key, data)
    return list(map(func, data[key]))


def asDecorator(data: dict) -> expr | None:
    #print("\n\nasDecorator: \n\t", data)
    
    match data["__class__"]["__name__"]:
        case Call.__name__:
            return Call(
                data["func"],
                dict_map(data, args=asArg),
                dict_map(data, keywords=asKeyword),
            )
        case Constant.__name__:
            return data["value"]
            
        case _: return None

def asKeyword(data: dict) -> keyword:
    return keyword(
        data["arg"],
        data["value"]
    )

def asReturn(data: dict | None) -> expr | None:
    if not data:
        return None
    match data["__class__"]["__name__"]:
        case Name.__name__: return Name(
                " "+data["id"]
            )
        case Constant.__name__: 
            return Constant(
                " "+data["value"]
            )
        case _: return None

def asAnnotation(data: dict | None) -> expr | None:
    #print("\n\asAnnotation: \n\t", data)
    if not data:
        return None
    match data["__class__"]["__name__"]:
        case Name.__name__: return Name(
                data["id"]
            )
        case Constant.__name__: 
            return Constant(
                data["value"]
            )
        case _: return None

def asArg(data: dict) -> arg:
    #print("\n\nasArg: \n\t", data)
    name = data["arg"]
    return arg(
        name,
        asAnnotation(data["annotation"]) if name != "self" else None
    )
def asArguments(data: dict) -> arguments:
    return arguments(
        #dict_map(data, posonlyargs=asArg),
        [],
        dict_map(data, args=asArg),
        None,
        dict_map(data, kwonlyargs=asArg),
        [],
        None,
        []
    )
    
def reorderBody(data: dict):
    clses = []
    rest = []
    for item in data["body"]:
        match item["__class__"]["__name__"]:
            
            case ClassDef.__name__:
                clses.append(item)
            case _:
                rest.append(item)
    data["body"] = clses + rest

def asBodyElement(data: dict) -> stmt | None:
    match data["__class__"]["__name__"]:
        case FunctionDef.__name__:
            name = data["name"]
            args = asArguments(data["args"])
            if name == "set_callback":
                args.args[1].annotation = BinOp(Name("Callback"), BitOr(), Name("CallbackDict"))
            return FunctionDef(
                data["name"],
                args,
                [Expr(ast.Ellipsis(None))],
                dict_map(data, decorator_list=asDecorator),
                asReturn(data["returns"])
                
            )
        case ClassDef.__name__:
            return createClassDef(data)
        case AnnAssign.__name__:
            return AnnAssign(
                Name(data["target"]["id"]),
                Name(data["annotation"]["id"]),
                None,
                0
            )
        case _: return None
        

def fromBase(data: dict) -> expr | None:

    match data["__class__"]["__name__"]:
        case Name.__name__: 
            return Name(data["id"])
        case _: return None
                

def createClassDef(data: dict) -> ClassDef:
    bases = [
        
    ]
    #reorderBody(data)
    cls = ClassDef(
        data["name"],
        dict_map(data, bases=fromBase),
        #list(map(fromBase, data["bases"])),
        dict_map(data, keywords=asKeyword),
        #list(map(asKeyword, data["keywords"])),
        dict_map(data, body=asBodyElement),
        #list(map(asBodyElement, data["body"])),
        dict_map(data, decorator_list=asDecorator),
        #list(map(asDecorator, data["decorator_list"]))
    )
    return cls

def createModule(data: dict) -> Module:
    body: list = [
        "from typing import Protocol, NewType, TypedDict, Callable\n",
    ]
    print(data["type_vars"])
    body.extend(
        [f"\n{x} = NewType(\"{x}\", object)" for x in data["type_vars"]]
    )
    body.extend(
        dict_map(data, body=asBodyElement)
    )
    m = Module(
        #list(map(fromBase, data["body"]))
        body,
        []
    )
    return m

def handleWrapper(data: dict) -> str:
    # pop_keys = list(data.keys())
    # for k in pop_keys:
    #     if k == "__class__":
    #         data.pop(k)
            
    m = createModule(data)
    
    for item in m.body:
        print(item.__class__)
    ast.fix_missing_locations(m)
    return to_source(
        m
    )
    
    
with open(src, 'r') as rf:
    code = handleWrapper(json_load(rf))
    with open(dst, 'w') as wf:
        wf.write(code)