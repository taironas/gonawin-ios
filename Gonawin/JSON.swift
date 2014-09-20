//
//  JSON.swift
//  Gonawin
//
//  Created by Remy JOURDE on 13/09/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import Foundation

typealias JSON = AnyObject
typealias JSONDictionary = Dictionary<String, AnyObject>
typealias JSONArray = Array<AnyObject>

func _JSONString(object: JSON) -> String? {
    return object as? String
}

func _JSONInt(object: JSON) -> Int? {
    return object as? Int
}

func _JSONObject(object: JSON) -> JSONDictionary? {
    return object as? JSONDictionary
}

func decodeJSON(data: NSData) -> Result<JSON> {
    let jsonOptional: JSON! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil)
    return resultFromOptional(jsonOptional, NSError()) // use the error from NSJSONSerialization or a custom error message
}

func decodeObject<U: JSONDecodable>(json: JSON) -> Result<U> {
    return resultFromOptional(U.decode(json), NSError())
}