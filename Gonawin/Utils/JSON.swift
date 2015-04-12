//
//  JSON.swift
//  Gonawin
//
//  Created by Remy JOURDE on 29/03/2015.
//  Copyright (c) 2015 Taironas. All rights reserved.
//

public typealias JSONDictionary = [String:AnyObject]
public typealias JSONArray = [JSONDictionary]

func decodeJSON(data: NSData) -> JSONDictionary? {
    return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil) as? JSONDictionary
}

func decodeJSONArray(data: NSData) -> JSONArray? {
    return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? JSONArray
}
