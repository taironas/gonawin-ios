//
//  MatchDay.swift
//  GonawinEngine
//
//  Created by Remy JOURDE on 16/03/2016.
//  Copyright © 2016 Remy Jourde. All rights reserved.
//

import SwiftyJSON

final public class MatchDay: JSONAble {
    public let day: String
    public let matches: [Match]
    
    public init(day: String, matches: [Match]) {
        self.day = day
        self.matches = matches
    }
    
    static func fromJSON(json: JSONDictionary) -> MatchDay {
        let json = JSON(json)
        
        return fromJSON(json)
    }
    
    static func fromJSON(json: JSON) -> MatchDay {
        
        let date = json["Date"].stringValue
        let matches = json["Matches"].arrayValue.map{ Match.fromJSON($0) }
        
        return MatchDay(day: date, matches: matches)
    }
}