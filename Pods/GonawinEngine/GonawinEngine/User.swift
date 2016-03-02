//
//  User.swift
//  GonawinEngine
//
//  Created by Remy JOURDE on 26/02/2016.
//  Copyright © 2016 Remy Jourde. All rights reserved.
//

import SwiftyJSON

final class User: JSONAble {
    let id: Int64
    let email: String
    let username: String
    let name: String
    let auth: String
    
    init(id: Int64, email: String, username: String, name: String, auth: String) {
        self.id = id
        self.email = email
        self.username = username
        self.name = name
        self.auth = auth
    }
    
    static func fromJSON(json: JSONDictionary) -> User {
        let json = JSON(json)
        
        let id  = json["id"].int64Value
        let email = json["email"].stringValue
        let username = json["username"].stringValue
        let name = json["name"].stringValue
        let auth = json["auth"].stringValue
        
        return User(id: id, email: email, username: username, name: name, auth: auth)
    }
}
