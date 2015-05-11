//
//  UnsafeSubscript.swift
//  UnsafeSubscriptSample
//
//  Created by Adolfo Rodriguez on 2014-12-03.
//

import UIKit

prefix operator ¿ { }

infix operator ¿ {associativity left precedence 160 }

infix operator <-- {precedence 158 }

infix operator -- {precedence 159 }

func -- (subs:UnsafeSubscript,content:AnyObject?) -> (UnsafeSubscript,AnyObject?) {
    return (subs,content)
}

func -- (subs:Int,content:AnyObject?) -> (UnsafeSubscript,AnyObject?) {
    return UnsafeSubscript(values: [.Index(subs)]) -- content
}

func -- (subs:String,content:AnyObject?) -> (UnsafeSubscript,AnyObject?) {
    return UnsafeSubscript(values: [.Key(subs)]) -- content
}

func <-- (inout object:AnyObject?,subsContent:(UnsafeSubscript,AnyObject?)) -> Void {
    let subs = subsContent.0
    let content:AnyObject? = subsContent.1
    
    
    if subs.values.count == 0 {
        object = content
    }else {
        var values = subs.values
        var firstValue = values.removeAtIndex(0)
        var innerSubs = UnsafeSubscript(values: values)
        
        if object == nil {
            var innerObject:AnyObject? = nil
            innerObject <-- innerSubs -- content
            
            if innerObject != nil {
                switch firstValue {
                case .Index(0):
                    object = [innerObject!] as AnyObject
                case .Key(let key):
                    object = [key:innerObject!] as AnyObject
                default:
                    break
                }
            }
            
        }else{
            
            switch firstValue {
            case .Index(let index):
                
                var innerObject:AnyObject? = object ¿ index
                
                if innerObject == nil {
                    if let array = object as? [AnyObject] {
                        if array.count == index {
                            var newObject:AnyObject? = nil
                            newObject <-- innerSubs -- content
                            
                            if newObject != nil {
                                var mutArray:[AnyObject] = array
                                mutArray.append(newObject!)
                                object = mutArray as AnyObject
                            }
                        }
                    }
                }else {
                    innerObject <-- innerSubs -- content
                    if innerObject == nil {
                        var array = object as! [AnyObject]
                        array.removeAtIndex(index)
                        object = array as AnyObject
                    }else{
                        var array = object as! [AnyObject]
                        array[index] = innerObject!
                        object = array as AnyObject
                    }
                }
                
            case .Key(let key):
                
                var innerObject:AnyObject? = object ¿ key
                
                if innerObject == nil {
                    if let dict = object as? [String:AnyObject] {
                        var newObject:AnyObject? = nil
                        newObject <-- innerSubs -- content
                        
                        if newObject != nil {
                            var mutDict:[String:AnyObject] = dict
                            mutDict[key] = newObject
                            object = mutDict as AnyObject
                        }
                    }
                }else {
                    innerObject <-- innerSubs -- content
                    if innerObject != nil {
                        var dict = object as! [String:AnyObject]
                        dict[key] = innerObject
                        object = dict as AnyObject
                    }
                }
            }
            
        }
    }
    
}

prefix func ¿ (index:Int) -> UnsafeSubscript {
    return UnsafeSubscript(values: [UnsafeSubscript.Value.Index(index)])
}

prefix func ¿ (key:String) -> UnsafeSubscript {
    return UnsafeSubscript(values: [UnsafeSubscript.Value.Key(key)])
}

func ¿ (index:Int,s:UnsafeSubscript) -> UnsafeSubscript {
    
    return UnsafeSubscript(values: (¿index).values + s.values)
}

func ¿ (key:String,s:UnsafeSubscript) -> UnsafeSubscript {
    
    return UnsafeSubscript(values: (¿key).values + s.values)
}

func ¿ (s:UnsafeSubscript,index:Int) -> UnsafeSubscript {
    
    return UnsafeSubscript(values: s.values + (¿index).values)
}

func ¿ (s:UnsafeSubscript,key:String) -> UnsafeSubscript {
    
    return UnsafeSubscript(values: s.values + (¿key).values)
    
}

func ¿ (s:UnsafeSubscript,t:UnsafeSubscript) -> UnsafeSubscript {
    
    return UnsafeSubscript(values: s.values + t.values)
}

func ¿ (key:String,index:Int) -> UnsafeSubscript {
    return ¿key ¿ ¿index
}

func ¿ (index:Int,key:String) -> UnsafeSubscript {
    return ¿index ¿ ¿key
}

func ¿ (key1:String,key2:String) -> UnsafeSubscript {
    return ¿key1 ¿ ¿key2
}

func ¿ (index1:Int,index2:Int) -> UnsafeSubscript {
    return ¿index1 ¿ ¿index2
}

func ¿ (a:[AnyObject]?,index:Int) -> AnyObject? {
    
    return (a as AnyObject?) ¿ index
    
}

func ¿ (a:[String:AnyObject]?,key:String) -> AnyObject? {
    
    return (a as AnyObject?) ¿ key
    
}

func ¿ (a:[String:AnyObject]?,s:UnsafeSubscript) -> AnyObject? {
    
    return (a as AnyObject?) ¿ s
    
}

func ¿ (a:[AnyObject]?,key:String) -> AnyObject? {
    
    return nil
    
}

func ¿ (a:[String:AnyObject]?,index:Int) -> AnyObject? {
    
    return nil
    
}

func ¿ (a:AnyObject?,index:Int) -> AnyObject? {
    
    return a ¿ ¿index
    
}

func ¿ (a:AnyObject?,key:String) -> AnyObject? {
    
    return a ¿ ¿key
    
}

func ¿ (a:AnyObject?,s:UnsafeSubscript) -> AnyObject? {
    
    
    
    if s.values.count == 0 {
        return a
    }else{
        var values = s.values
        let first = values.removeAtIndex(0)
        switch a {
        case let array as [AnyObject]:
            switch first {
            case let .Index(index):
                
                if array.count > index && index >= 0 {
                    return array[index] ¿ UnsafeSubscript(values:values)
                }else{
                    return nil
                }
            default:
                return nil
            }
        case let dict as [String:AnyObject]:
            switch s.values.first! {
            case let .Key(key):
                return dict[key] ¿ UnsafeSubscript(values:values)
            default:
                return nil
            }
        default:
            return nil
        }
    }
    
}

func ¿<A,B> (a: A?, f: A -> B?) -> B? {
    if let x = a {
        return f(x)
    } else {
        return nil
    }
}

func UnsafeString<A>(object: A) -> String? {
    if let objString = object as? String {
        return objString
    }else if let objNumber = object as? NSNumber {
        return objNumber.stringValue
    }else {
        return nil
    }
}

func UnsafeToString(object:Int) -> String? {
    return String(object)
}

func UnsafeToString(object:Double) -> String? {
    return "\(object)"
}

func UnsafeDouble<A>(object: A) -> Double? {
    return (object as? Double) ?? (object as? NSString)?.doubleValue
}

func UnsafeInt<A>(object: A) -> Int? {
    return (object as? Int) ?? (object as? NSString)?.integerValue
}

func UnsafeDictionary<A>(object: A) -> Dictionary<String,AnyObject>? {
    return object as? Dictionary<String,AnyObject>
}

func UnsafeArray<A>(object: A) -> Array<AnyObject>? {
    return object as? Array<AnyObject>
}

struct UnsafeSubscript {
    
    enum Value {
        case Index(Int)
        case Key(String)
    }
    
    let values:[Value]
    
    init(_ rawValue:String) {
        self.values = [Value.Key(rawValue)]
    }
    
    init(_ rawValue:Int) {
        self.values = [Value.Index(rawValue)]
    }
    
    init(values:[Value]) {
        self.values = values
    }
    
    init?(_ rawValues:[AnyObject]) {
        var val:[Value] = []
        for raw in rawValues {
            if let i = raw as? Int {
                val.append(Value.Index(i))
            }else if let s = raw as? String {
                val.append(Value.Key(s))
            }else {
                return nil
            }
        }
        
        self.init(values: val)
        
    }
    
}