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
    public let description: String?
    public let accuracy: Double?
    public let joined: Bool?
    public let members: [User]?
    public let tournaments: [Tournament]?
    
    public init(id: Int64, name: String, membersCount: Int64, isPrivate: Bool, imageURL: String, description: String? = nil, accuracy: Double? = nil, joined: Bool? = nil, members: [User]? = nil, tournaments: [Tournament]? = nil) {
        self.id = id
        self.name = name
        self.membersCount = membersCount
        self.isPrivate = isPrivate
        self.imageURL = imageURL
        self.description = description
        self.accuracy = accuracy
        self.joined = joined
        self.members = members
        self.tournaments = tournaments
    }
    
    static func fromJSON(json: JSONDictionary) -> Team {
        let json = JSON(json)
        
        if json["Team"].isExists() {
            let jsonTeam = json["Team"]
            
            let id = jsonTeam["Id"].int64Value
            let name = jsonTeam["Name"].stringValue
            let description = jsonTeam["Description"].stringValue
            let isPrivate = jsonTeam["Private"].boolValue
            let accuracy = jsonTeam["Accuracy"].doubleValue
            let joined = json["Joined"].boolValue
            let members = json["Players"].arrayValue.map{ User.fromJSON($0) }
            let tournaments = json["Tournaments"].arrayValue.map{ Tournament.fromJSON($0) }
            let imageURL = json["ImageURL"].stringValue
            
            return Team(id: id, name: name, membersCount: Int64(members.count), isPrivate: isPrivate, imageURL: imageURL, description: description, accuracy: accuracy, joined: joined, members: members, tournaments: tournaments)
        }
        
        let id  = json["Id"].int64Value
        let name = json["Name"].stringValue
        let membersCount = json["MembersCount"].int64Value
        let isPrivate = json["Private"].boolValue
        let imageURL = json["ImageURL"].stringValue
        
        return Team(id: id, name: name, membersCount: membersCount, isPrivate: isPrivate, imageURL: imageURL)
    }
}
