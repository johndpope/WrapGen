//
//  TranslationUnit+Lookup.swift
//  WrapGen
//
//  Created by Harlan Haskins on 1/25/17.
//
//

import Foundation
import Clang


struct EnumDeclString  {
    var enumDecl: EnumDecl
    var str: String
    
    init(_ enumDecl: EnumDecl,_ str:String) {
        self.enumDecl = enumDecl
        self.str = str
    }
}

extension EnumDeclString: Equatable {}

func ==(lhs: EnumDeclString, rhs: EnumDeclString) -> Bool {
    let areEqual = lhs.str == rhs.str &&
        lhs.enumDecl == rhs.enumDecl
    return areEqual
}

extension Array where Element : Equatable {
    func distinct() -> [Element]{
        var unique = [Element]()
        for i in self{
            if let item = i as? Element {
                if !unique.contains(item){
                    unique.append(item)
                }
            }
        }
        return unique
    }
}

extension TranslationUnit {
    func allEnums() -> [EnumDeclString] {
        var decls = [EnumDeclString]()

        for child in cursor.children() {
            if let enumDecl = child as? EnumDecl {
                let obj = EnumDeclString(enumDecl,  "enum \(enumDecl)")
                decls.append(obj)
                
               // if let newTypeValue = newType.value{
                //    generateStructs(forEnum: enumDecl,
                //                    type: newTypeValue,
                //                    extraction: extraction,
                 //                   suffix: suffix.value ?? "")
               // }else{
                    generateStructs(forEnum: enumDecl,
                                    type: enumDecl.description,
                                    extraction: extraction,
                                    suffix:  "")
               // }
               

                
            } else if let decl = child as? TypedefDecl,
                let underlying = decl.underlying,
                let enumDecl = underlying.declaration as? EnumDecl{
                let obj = EnumDeclString(enumDecl,  "\(underlying)")
                decls.append(obj)
            }else if let fn = child as? FunctionDecl{
                print("func ",fn,"()")
                for i in 0...20{
                    if let param = fn.parameter(at: i){
                        
                        for parameterType in param.children(){
                            let param = "\(param.description) : \(parameterType)"
                            print(param)
                        }
                    }
                }
                if let rType = fn.resultType{
                   print("->", rType)
                    let cStr = rType.description
                    if(cStr == "const char *"){
                        print("-> UnsafeMutablePointer<CChar>.self")
                    }
                    
                    if(cStr == "void"){
                        print("-> void")
                    }
                    //
                }
            }else if let _ = child as? TypedefDecl {
                print("TypedefDecl:",child)
            }else if let structDecl = child as? StructDecl {
                print("StructDecl:",structDecl)
                print("type:",structDecl.type )
                if (structDecl.children().count != 0){
                    for structDeclChild in structDecl.children(){
                        if let sChild = structDeclChild as? Clang.FieldDecl{
                           print("field:",sChild)
                        }else{
                           print("unknown child:",structDeclChild)
                        }
                    }
                }

            }else if let _ = child as? UnionDecl {
                print("UnionDecl:",child)
            }else  {
                print("unknown:",child)
            }
            
            
            print("\n\n")
        }
        return decls.distinct()
    }
    func findEnum(name: String) -> EnumDecl? {
        for child in cursor.children() {
            if let enumDecl = child as? EnumDecl, "\(enumDecl)" == name {
                return enumDecl
            }
            if let decl = child as? TypedefDecl,
                let underlying = decl.underlying,
                "\(underlying)" == "enum \(name)" {
                return underlying.declaration as? EnumDecl
            }
        }
        return nil
    }
}
