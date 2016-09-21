//
//  TournamentCalendar.swift
//  GonawinEngine
//
//  Created by Remy JOURDE on 16/03/2016.
//  Copyright © 2016 Remy Jourde. All rights reserved.
//

import SwiftyJSON

final public class TournamentCalendar: JSONAble {
    public let days: [MatchDay]
    
    public init(days: [MatchDay]) {
        self.days = days
    }
    
    static func fromJSON(_ json: JSONDictionary) -> TournamentCalendar {
        let json = JSON(json)
        
        return from(json: json)
    }
    
    static func from(json: JSON) -> TournamentCalendar {
        
        let days = json["Days"].arrayValue.map{ MatchDay.fromJSON($0) }
        
        return TournamentCalendar(days: days)
    }
}
