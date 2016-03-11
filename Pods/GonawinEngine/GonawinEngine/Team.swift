//
//  Team.swift
//  GonawinEngine
//
//  Created by Remy JOURDE on 09/03/2016.
//  Copyright © 2016 Remy Jourde. All rights reserved.
//

import SwiftyJSON

final public class Team: JSONAble {
    public let id: Int64
    public let name: String
    public let membersCount: Int64
    public let isPrivate: Bool
    public let imageURL: String
    
    public init(id: Int64, name: String, membersCount: Int64, isPrivate: Bool, imageURL: String) {
        self.id = id
        self.name = name
        self.membersCount = membersCount
        self.isPrivate = isPrivate
        self.imageURL = imageURL
    }
    
    static func fromJSON(json: JSONDictionary) -> Team {
        let json = JSON(json)
        
        let id  = json["Id"].int64Value
        let name = json["Name"].stringValue
        let membersCount = json["MembersCount"].int64Value
        let isPrivate = json["Private"].boolValue
        let imageURL = json["ImageURL"].stringValue
        
        return Team(id: id, name: name, membersCount: membersCount, isPrivate: isPrivate, imageURL: imageURL)
    }
}
