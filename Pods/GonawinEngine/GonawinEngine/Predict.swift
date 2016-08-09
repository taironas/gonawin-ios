//
//  Predict.swift
//  GonawinEngine
//
//  Created by Remy JOURDE on 15/04/2016.
//  Copyright © 2016 Remy Jourde. All rights reserved.
//

import SwiftyJSON

final public class Predict: JSONAble {
    public let id: Int64
    public let userId: Int64
    public let matchId: Int64
    public let homeTeamScore: Int64
    public let awayTeamScore: Int64
    
    public init(id: Int64, userId: Int64, matchId: Int64, homeTeamScore: Int64, awayTeamScore: Int64) {
        self.id = id
        self.userId = userId
        self.matchId = matchId
        self.homeTeamScore = homeTeamScore
        self.awayTeamScore = awayTeamScore
    }
    
    static func fromJSON(json: JSONDictionary) -> Predict {
        let json = JSON(json)
        
        return fromJSON(json)
    }
    
    static func fromJSON(json: JSON) -> Predict {
        
        let jsonPredict = json["Predict"]
        
        let id = jsonPredict["Id"].int64Value
        let userId = jsonPredict["UserId"].int64Value
        let matchId = jsonPredict["MatchId"].int64Value
        let homeTeamScore = jsonPredict["Result1"].int64Value
        let awayTeamScore = jsonPredict["Result2"].int64Value
        
        return Predict(id: id, userId: userId, matchId: matchId, homeTeamScore: homeTeamScore, awayTeamScore: awayTeamScore)
    }
}
