//
//  FBUserInfo.swift
//  Gonawin
//
//  Created by Remy JOURDE on 15/02/2015.
//  Copyright (c) 2015 Taironas. All rights reserved.
//

struct FBUserInfo: JSONDecodable {
    var id: String
    var email: String
    var name: String
}

extension FBUserInfo: JSONDecodable {
    static func create(id: String)(email: String)(name: String) -> FBUserInfo {
        return FBUserInfo(id: id, email: email, name: name)
    }
    
    static func decode(json: JSON) -> FBUserInfo? {
        return _JSONObject(json) >>> { ui in
            FBUserInfo.create <^>
                ui["id"]     >>> _JSONString  <*>
                ui["email"]  >>> _JSONString  <*>
                ui["name"]   >>> _JSONString
        }
    }
}