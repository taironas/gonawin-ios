// This code is provided under the MIT license:
// Copyright (c) 2014 Chris Eidhof
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software
// without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
// persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
// PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
// OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

// This code accompanies a blog post: http://chris.eidhof.nl/posts/json-parsing-in-swift.html

infix operator  <*> { associativity left precedence 150 }
func <*><A, B>(l: (A -> B)?, r: A?) -> B? {
    if let l1 = l {
        if let r1 = r {
            return l1(r1)
        }
    }
    return nil
}

func flatten<A>(x: A??) -> A? {
    if let y = x { return y }
    return nil
}

func array(input: [String:AnyObject], key: String) ->  [AnyObject]? {
    let maybeAny : AnyObject? = input[key]
    return maybeAny >>>= { $0 as? [AnyObject] }
}

func dictionary(input: [String:AnyObject], key: String) ->  [String:AnyObject]? {
    return input[key] >>>= { $0 as? [String:AnyObject] }
}

func string(input: [String:AnyObject], key: String) -> String? {
    return input[key] >>>= { $0 as? String }
}

func number(input: [NSObject:AnyObject], key: String) -> NSNumber? {
    return input[key] >>>= { $0 as? NSNumber }
}

func int(input: [NSObject:AnyObject], key: String) -> Int? {
    return number(input,key).map { $0.integerValue }
}

func bool(input: [NSObject:AnyObject], key: String) -> Bool? {
    return number(input,key).map { $0.boolValue }
}


func curry<A,B,R>(f: (A,B) -> R) -> A -> B -> R {
    return { a in { b in f(a,b) } }
}

func curry<A,B,C,R>(f: (A,B,C) -> R) -> A -> B -> C -> R {
    return { a in { b in {c in f(a,b,c) } } }
}

func curry<A,B,C,D,R>(f: (A,B,C,D) -> R) -> A -> B -> C -> D -> R {
    return { a in { b in { c in { d in f(a,b,c,d) } } } }
}

infix operator  >>>= {}

func >>>= <A,B> (optional : A?, f : A -> B?) -> B? {
    return flatten(optional.map(f))
}

