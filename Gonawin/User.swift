//
//  User.swift
//  Gonawin
//
//  Created by Remy JOURDE on 13/09/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import Foundation
import Alamofire

struct User {
    let id: Int
    let email: String
    let username: String
    let name: String
}

extension User: JSONDecodable {
    static func create(id: Int)(email: String)(username: String)(name: String) -> User {
        return User(id: id, email: email, username: username, name: name)
    }
    
    static func decode(json: JSON) -> User? {
        println(json)
        return _JSONObject(json) >>> { d in
            d["User"]   >>> _JSONObject >>> { u in
                User.create <^>
                    u["Id"]     >>> _JSONInt    <*>
                    u["Email"]   >>> _JSONString <*>
                    u["Username"]   >>> _JSONString <*>
                    u["Name"]  >>> _JSONString
            }
        }
    }
}