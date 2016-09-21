//
//  JSON.swift
//  Gonawin
//
//  Created by Remy JOURDE on 29/03/2015.
//  Copyright (c) 2015 Taironas. All rights reserved.
//

public typealias JSONDictionary = [String:AnyObject]
public typealias JSONArray = [JSONDictionary]

func decodeJSON(_ data: Data) -> JSONDictionary? {
    return (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())) as? JSONDictionary
}

func decodeJSONArray(_ data: Data) -> JSONArray? {
    return (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? JSONArray
}
