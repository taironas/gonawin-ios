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
    return (try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())) as? JSONDictionary
}

func decodeJSONArray(data: NSData) -> JSONArray? {
    return (try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)) as? JSONArray
}
