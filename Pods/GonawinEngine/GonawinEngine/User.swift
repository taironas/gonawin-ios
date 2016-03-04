//
//  User.swift
//  GonawinEngine
//
//  Created by Remy JOURDE on 26/02/2016.
//  Copyright © 2016 Remy Jourde. All rights reserved.
//

import SwiftyJSON

final public class User: JSONAble {
    public let id: Int64
    public let email: String
    public let username: String
    public let name: String
    public let alias: String
    public let auth: String
    public let predictIds = [Int64]()
    public let archivedPredictIds = [Int64]()
    public let tournamentIds = [Int64]()
    public let archivedTournamentIds = [Int64]()
    public let teamIds = [Int64]()
    public let score: Int64
    public let scoreOfTournaments = [Int64]()
    public let activityIds = [Int64]()
    public let imageURL: String
    
    public init(id: Int64, email: String, username: String, name: String, alias: String, auth: String, predictIds: [Int64] = [Int64](), archivedPredictIds: [Int64] = [Int64](), tournamentIds: [Int64] = [Int64](), archivedTournamentIds: [Int64] = [Int64](), teamIds: [Int64] = [Int64](), score: Int64 = 0, scoreOfTournaments: [Int64] = [Int64](), activityIds: [Int64] = [Int64](), imageURL: String = "") {
        self.id = id
        self.email = email
        self.username = username
        self.alias = alias
        self.name = name
        self.auth = auth
        self.score = score
        self.imageURL = imageURL
    }
    
    static func fromJSON(json: JSONDictionary) -> User {
        let json = JSON(json)
        
        let jsonUser = json["User"]
        
        let id  = jsonUser["Id"].int64Value
        let email = jsonUser["Email"].stringValue
        let username = jsonUser["Username"].stringValue
        let name = jsonUser["Name"].stringValue
        let alias = jsonUser["Alias"].stringValue
        let auth = jsonUser["Auth"].stringValue
        let predictIds = jsonUser["PredictIds"].arrayValue.map{ $0.int64Value }
        let archivedPredictIds = jsonUser["ArchivedPredictInds"].arrayValue.map{ $0.int64Value }
        let tournamentIds = jsonUser["TournamentIds"].arrayValue.map{ $0.int64Value }
        let archivedTournamentIds = jsonUser["ArchivedTournamentIds"].arrayValue.map{ $0.int64Value }
        let teamIds = jsonUser["TeamIds"].arrayValue.map{ $0.int64Value }
        let score = jsonUser["Score"].int64Value
        let scoreOfTournaments = jsonUser["ScoreOfTournaments"].arrayValue.map{ $0.int64Value }
        let activityIds = jsonUser["ActivityIds"].arrayValue.map{ $0.int64Value }
        
        let imageURL = json["ImageURL"].stringValue
        
        return User(id: id, email: email, username: username, name: name, alias: alias, auth: auth, predictIds: predictIds, archivedPredictIds: archivedPredictIds, tournamentIds: tournamentIds, archivedTournamentIds: archivedTournamentIds, teamIds: teamIds, score: score, scoreOfTournaments: scoreOfTournaments, activityIds: activityIds, imageURL: imageURL)
    }
}
