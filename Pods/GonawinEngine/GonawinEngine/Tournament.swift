//
//  Tournament.swift
//  GonawinEngine
//
//  Created by Remy JOURDE on 11/03/2016.
//  Copyright © 2016 Remy Jourde. All rights reserved.
//

import SwiftyJSON

final public class Tournament: JSONAble {
    public let id: Int64
    public let name: String
    public let participantsCount: Int64
    public let teamsCount: Int64
    public let progress: Int64
    public let imageURL: String
    
    public init(id: Int64, name: String, participantsCount: Int64, teamsCount: Int64, progress: Int64, imageURL: String) {
        self.id = id
        self.name = name
        self.participantsCount = participantsCount
        self.teamsCount = teamsCount
        self.progress = progress
        self.imageURL = imageURL
    }
    
    static func fromJSON(json: JSONDictionary) -> Tournament {
        let json = JSON(json)
        
        return fromJSON(json)
    }
    
    static func fromJSON(json: JSON) -> Tournament {
        let id  = json["Id"].int64Value
        let name = json["Name"].stringValue
        let participantsCount = json["ParticipantsCount"].int64Value
        let teamsCount = json["TeamsCount"].int64Value
        let progress = json["Progress"].int64Value
        let imageURL = json["ImageURL"].stringValue
        
        return Tournament(id: id, name: name, participantsCount: participantsCount, teamsCount: teamsCount, progress: progress, imageURL: imageURL)
    }
}
