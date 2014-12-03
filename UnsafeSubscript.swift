//
//  UnsafeSubscript.swift
//  UnsafeSubscriptSample
//
//  Created by Adolfo Rodriguez on 2014-12-03.
//

import UIKit

prefix operator ¿ { }

infix operator ¿ {associativity left precedence 160 }

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
                if array.count > index && index > 0 {
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
    return object as? String
}

func UnsafeNumber<A>(object: A) -> Double? {
    return object as? Double
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
    
    
}