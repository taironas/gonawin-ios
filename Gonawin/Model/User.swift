//
//  User.swift
//  Gonawin
//
//  Created by Remy JOURDE on 13/09/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

struct User {
    var id: Int
    var email: String
    var username: String
    var name: String
    var auth: String
    
    func encoded() -> [String:AnyObject] {
        return ["Id": id, "Email": email, "Username": username, "Name": name]
    }
}

func parseUser(dict: JSONDictionary) -> User? {
    let makeUser = { User(id: $0, email: $1, username: $2, name: $3, auth: "") }
    
    return curry(makeUser)
        <*> int(dict, "Id")
        <*> string(dict, "Email")
        <*> string(dict, "Username")
        <*> string(dict, "Name")
}

func getAuthToken(dict: JSONDictionary) -> String? {
    return string(dict, "Auth")
}