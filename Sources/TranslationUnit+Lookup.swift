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

            
            var fnParams:[String] = ["func "]
            if let enumDecl = child as? EnumDecl {
                
                let obj = EnumDeclString(enumDecl,  "enum \(enumDecl)")
                decls.append(obj)
                
              
                    generateStructs(forEnum: enumDecl,
                                    type: enumDecl.description,
                                    extraction: extraction,
                                    suffix:  "")
               
                generateSwiftEnum(forEnum: enumDecl,
                                  enumName: enumDecl.description,
                                  extraction: extraction,
                                  name: enumDecl.description)
                
                generateSwiftOptionSet(forEnum: enumDecl,
                                    enumName: enumDecl.description,
                                    extraction: extraction,
                                    name: enumDecl.description)
                
               

                
            } else if let decl = child as? TypedefDecl,
                let underlying = decl.underlying,
                let enumDecl = underlying.declaration as? EnumDecl{
                let obj = EnumDeclString(enumDecl,  "\(underlying)")
                decls.append(obj)
            }else if let fn = child as? FunctionDecl{
               
                fnParams.append("\(fn.description)(") // eg. [func  ,TF_DeleteLibraryHandle(]
                for i in 0...20{
                    
                    var bPeakAhead = false
                    if let _ = fn.parameter(at: i+1){
                        bPeakAhead = true
                    }
                    if let param = fn.parameter(at: i){
                        let n = param.children().count
                        for parameterType in param.children(){
                            let param = "\(param.description) : \(parameterType)"
                            fnParams.append(param)
                        }
                        if (bPeakAhead){
                            if (n > 0){
                              fnParams.append(",")
                            }
                        }
                    }else{
                        fnParams.append(")")
                        break;
                        
                    }
                    
                }
                
                if let rType = fn.resultType{
                    let cStr = rType.description
                    if(cStr == "const char *"){
                        fnParams.append(" -> UnsafeMutablePointer<CChar>.self")
                    }
                    
                    if(cStr == "void"){
                        fnParams.append(" ->  UnsafePointer<Void>")
                    }
                    //
                }
                let fnDefinition =  fnParams.joined()
                print(fnDefinition)
                
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
