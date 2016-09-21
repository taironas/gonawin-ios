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
    public let joined: Bool?
    public let participants: [User]?
    public let teams: [Team]?
    public let start: String?
    public let end: String?
    public let remainingDays: String?
    
    public init(id: Int64, name: String, participantsCount: Int64, teamsCount: Int64, progress: Int64, imageURL: String, joined: Bool? = nil, participants: [User]? = nil, teams: [Team]? = nil, start: String? = nil, end: String? = nil, remainingDays: String? = nil) {
        self.id = id
        self.name = name
        self.participantsCount = participantsCount
        self.teamsCount = teamsCount
        self.progress = progress
        self.imageURL = imageURL
        self.joined = joined
        self.participants = participants
        self.teams = teams
        self.start = start
        self.end = end
        self.remainingDays = remainingDays
    }
    
    static func fromJSON(_ json: JSONDictionary) -> Tournament {
        let json = JSON(json)
        
        return fromJSON(json)
    }
    
    static func fromJSON(_ json: JSON) -> Tournament {
        if json["Tournament"].exists() {
            let jsonTournament = json["Tournament"]
            
            let id = jsonTournament["Id"].int64Value
            let name = jsonTournament["Name"].stringValue
            let progress = json["Progress"].int64Value
            let joined = json["Joined"].boolValue
            let participants = json["Participants"].arrayValue.map{ User.fromJSON($0) }
            let teams = json["Teams"].arrayValue.map{ Team.fromJSON($0) }
            let start = json["Start"].stringValue
            let end = json["End"].stringValue
            let remainingDays = json["RemainingDays"].stringValue
            let imageURL = json["ImageURL"].stringValue
            
            return Tournament(id: id, name: name, participantsCount: Int64(participants.count), teamsCount: Int64(teams.count), progress: progress, imageURL: imageURL, joined:  joined, participants:  participants, teams: teams, start: start, end: end, remainingDays: remainingDays)
        }
        
        let id  = json["Id"].int64Value
        let name = json["Name"].stringValue
        let participantsCount = json["ParticipantsCount"].int64Value
        let teamsCount = json["TeamsCount"].int64Value
        let progress = json["Progress"].int64Value
        let imageURL = json["ImageURL"].stringValue
        
        return Tournament(id: id, name: name, participantsCount: participantsCount, teamsCount: teamsCount, progress: progress, imageURL: imageURL)
    }
}
