//
//  User.swift
//  Gonawin
//
//  Created by Remy JOURDE on 13/09/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

struct User: JSONDecodable {
    var id: Int
    var email: String
    var username: String
    var name: String
    
    func encoded() -> [String:AnyObject] {
        return ["id": self.id, "email": self.email, "username": self.username, "name": self.name]
    }
}

extension User: JSONDecodable {
    static func create(id: Int)(email: String)(username: String)(name: String) -> User {
        return User(id: id, email: email, username: username, name: name)
    }
    
    static func decode(json: JSON) -> User? {
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
    
    static func decode(dico: [String:AnyObject]) -> User? {
        return dico >>> _JSONObject >>> { u in
            User.create <^>
                u["Id"]     >>> _JSONInt    <*>
                u["Email"]   >>> _JSONString <*>
                u["Username"]   >>> _JSONString <*>
                u["Name"]  >>> _JSONString
        }
    }
}