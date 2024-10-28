////
////  File.swift
////  
////
////  Created by CodeBuilder on 28/10/2024.
////
//
//import Foundation
//import PySwiftCore
//import PythonCore
//import PyAst
//import PySwiftObject
//
//extension AST {
//	public class NodeVisitor {
//		
//	}
//	
//}
//
//fileprivate func _tp_dealloc(_ object: PySwiftObjectPointer) {
//	fatalError()
//}
//
//extension AST.NodeVisitor {
//	static func __tp_dealloc(_ object: PyPointer?) {
//		fatalError()
//	}
//	
//	static var PyType: PyTypeObject = .init(
//		ob_base: .init(),
//		tp_name: <#T##UnsafePointer<CChar>!#>,
//		tp_basicsize: <#T##Py_ssize_t#>,
//		tp_itemsize: <#T##Py_ssize_t#>,
//		tp_dealloc: unsafeBitCast(_tp_dealloc, to: destructor.self),
//		tp_vectorcall_offset: <#T##Py_ssize_t#>,
//		tp_getattr: <#T##getattrfunc!##getattrfunc!##(UnsafeMutablePointer<PyObject>?, UnsafeMutablePointer<CChar>?) -> UnsafeMutablePointer<PyObject>?#>,
//		tp_setattr: <#T##setattrfunc!##setattrfunc!##(UnsafeMutablePointer<PyObject>?, UnsafeMutablePointer<CChar>?, UnsafeMutablePointer<PyObject>?) -> Int32#>,
//		tp_as_async: <#T##UnsafeMutablePointer<PyAsyncMethods>!#>,
//		tp_repr: <#T##reprfunc!##reprfunc!##(UnsafeMutablePointer<PyObject>?) -> UnsafeMutablePointer<PyObject>?#>,
//		tp_as_number: <#T##UnsafeMutablePointer<PyNumberMethods>!#>,
//		tp_as_sequence: <#T##UnsafeMutablePointer<PySequenceMethods>!#>,
//		tp_as_mapping: <#T##UnsafeMutablePointer<PyMappingMethods>!#>,
//		tp_hash: { <#UnsafeMutablePointer<PyObject>?#> in
//			<#code#>
//		},
//		tp_call: <#T##ternaryfunc!##ternaryfunc!##(UnsafeMutablePointer<PyObject>?, UnsafeMutablePointer<PyObject>?, UnsafeMutablePointer<PyObject>?) -> UnsafeMutablePointer<PyObject>?#>,
//		tp_str: <#T##reprfunc!##reprfunc!##(UnsafeMutablePointer<PyObject>?) -> UnsafeMutablePointer<PyObject>?#>,
//		tp_getattro: <#T##getattrofunc!##getattrofunc!##(UnsafeMutablePointer<PyObject>?, UnsafeMutablePointer<PyObject>?) -> UnsafeMutablePointer<PyObject>?#>,
//		tp_setattro: <#T##setattrofunc!##setattrofunc!##(UnsafeMutablePointer<PyObject>?, UnsafeMutablePointer<PyObject>?, UnsafeMutablePointer<PyObject>?) -> Int32#>,
//		tp_as_buffer: <#T##UnsafeMutablePointer<PyBufferProcs>!#>,
//		tp_flags: <#T##UInt#>,
//		tp_doc: <#T##UnsafePointer<CChar>!#>,
//		tp_traverse: <#T##traverseproc!##traverseproc!##(UnsafeMutablePointer<PyObject>?, visitproc?, UnsafeMutableRawPointer?) -> Int32#>,
//		tp_clear: <#T##inquiry!##inquiry!##(UnsafeMutablePointer<PyObject>?) -> Int32#>,
//		tp_richcompare: <#T##richcmpfunc!##richcmpfunc!##(UnsafeMutablePointer<PyObject>?, UnsafeMutablePointer<PyObject>?, Int32) -> UnsafeMutablePointer<PyObject>?#>,
//		tp_weaklistoffset: <#T##Py_ssize_t#>,
//		tp_iter: <#T##getiterfunc!##getiterfunc!##(UnsafeMutablePointer<PyObject>?) -> UnsafeMutablePointer<PyObject>?#>,
//		tp_iternext: <#T##iternextfunc!##iternextfunc!##(UnsafeMutablePointer<PyObject>?) -> UnsafeMutablePointer<PyObject>?#>,
//		tp_methods: <#T##UnsafeMutablePointer<PyMethodDef>!#>,
//		tp_members: <#T##OpaquePointer!#>,
//		tp_getset: <#T##UnsafeMutablePointer<PyGetSetDef>!#>,
//		tp_base: <#T##UnsafeMutablePointer<PyTypeObject>!#>,
//		tp_dict: <#T##UnsafeMutablePointer<PyObject>!#>,
//		tp_descr_get: <#T##descrgetfunc!##descrgetfunc!##(UnsafeMutablePointer<PyObject>?, UnsafeMutablePointer<PyObject>?, UnsafeMutablePointer<PyObject>?) -> UnsafeMutablePointer<PyObject>?#>,
//		tp_descr_set: <#T##descrsetfunc!##descrsetfunc!##(UnsafeMutablePointer<PyObject>?, UnsafeMutablePointer<PyObject>?, UnsafeMutablePointer<PyObject>?) -> Int32#>,
//		tp_dictoffset: <#T##Py_ssize_t#>,
//		tp_init: <#T##initproc!##initproc!##(UnsafeMutablePointer<PyObject>?, UnsafeMutablePointer<PyObject>?, UnsafeMutablePointer<PyObject>?) -> Int32#>,
//		tp_alloc: <#T##allocfunc!##allocfunc!##(UnsafeMutablePointer<PyTypeObject>?, Py_ssize_t) -> UnsafeMutablePointer<PyObject>?#>,
//		tp_new: <#T##newfunc!##newfunc!##(UnsafeMutablePointer<PyTypeObject>?, UnsafeMutablePointer<PyObject>?, UnsafeMutablePointer<PyObject>?) -> UnsafeMutablePointer<PyObject>?#>,
//		tp_free: <#T##freefunc!##freefunc!##(UnsafeMutableRawPointer?) -> Void#>,
//		tp_is_gc: <#T##inquiry!##inquiry!##(UnsafeMutablePointer<PyObject>?) -> Int32#>,
//		tp_bases: <#T##UnsafeMutablePointer<PyObject>!#>,
//		tp_mro: <#T##UnsafeMutablePointer<PyObject>!#>,
//		tp_cache: <#T##UnsafeMutablePointer<PyObject>!#>,
//		tp_subclasses: <#T##UnsafeMutablePointer<PyObject>!#>,
//		tp_weaklist: <#T##UnsafeMutablePointer<PyObject>!#>,
//		tp_del: <#T##destructor!##destructor!##(UnsafeMutablePointer<PyObject>?) -> Void#>,
//		tp_version_tag: <#T##UInt32#>,
//		tp_finalize: <#T##destructor!##destructor!##(UnsafeMutablePointer<PyObject>?) -> Void#>,
//		tp_vectorcall: <#T##vectorcallfunc!##vectorcallfunc!##(UnsafeMutablePointer<PyObject>?, UnsafePointer<UnsafeMutablePointer<PyObject>?>?, Int, UnsafeMutablePointer<PyObject>?) -> UnsafeMutablePointer<PyObject>?#>
//	)
//}
