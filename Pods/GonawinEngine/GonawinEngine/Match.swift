//
//  Match.swift
//  GonawinEngine
//
//  Created by Remy JOURDE on 16/03/2016.
//  Copyright © 2016 Remy Jourde. All rights reserved.
//

import SwiftyJSON

final public class Match: JSONAble {
    public let id: Int64
    public let idNUmber: Int64
    public let date: String
    public let team1: String
    public let team2: String
    public let iso1: String
    public let iso2: String
    public let location: String
    public let result1: Int64
    public let result2: Int64
    public let hasPredict: Bool
    public let predict: String
    public let finished: Bool
    public let ready: Bool
    public let canPredict: Bool
    
    public init(id: Int64, idNumber: Int64, date: String, team1: String, team2: String, iso1: String, iso2: String, location: String, result1: Int64, result2: Int64, hasPredict: Bool, predict: String, finished: Bool, ready: Bool, canPredict: Bool)
    {
        self.id = id
        self.idNUmber = idNumber
        self.date = date
        self.team1 = team1
        self.team2 = team2
        self.iso1 = iso2
        self.iso2 = iso2
        self.location = location
        self.result1 = result1
        self.result2 = result2
        self.hasPredict = hasPredict
        self.predict = predict
        self.finished = finished
        self.ready = ready
        self.canPredict = canPredict
    }
    
    static func fromJSON(json: JSONDictionary) -> Match {
        let json = JSON(json)
        
        return fromJSON(json)
    }
    
    static func fromJSON(json: JSON) -> Match {
        let id = json["Id"].int64Value
        let idNumber = json["IdNumber"].int64Value
        let date = json["Date"].stringValue
        let team1 = json["Team1"].stringValue
        let team2 = json["Team2"].stringValue
        let iso1 = json["Iso1"].stringValue
        let iso2 = json["Iso2"].stringValue
        let location = json["Location"].stringValue
        let result1 = json["Result1"].int64Value
        let result2 = json["Result2"].int64Value
        let hasPredict = json["HasPredict"].boolValue
        let predict = json["Predict"].stringValue
        let finished = json["Finished"].boolValue
        let ready = json["Ready"].boolValue
        let canPredict = json["CanPredict"].boolValue
        
        return Match(id: id, idNumber: idNumber, date: date, team1: team1, team2: team2, iso1: iso1, iso2: iso2, location: location, result1: result1, result2: result2, hasPredict: hasPredict, predict: predict, finished: finished, ready: ready, canPredict: canPredict)
    }
}