//
//  Activity.swift
//  GonawinEngine
//
//  Created by Remy JOURDE on 05/03/2016.
//  Copyright © 2016 Remy Jourde. All rights reserved.
//

import SwiftyJSON

final public class ActivityResults: JSONAble {
    public let total: Int64
    public let perPage: Int64
    public let currentPage: Int64
    public let lastPage: Int64
    public let activities: [Activity]
    
    public init(total: Int64, perPage: Int64, currentPage: Int64, lastPage: Int64, activities: [Activity]) {
        self.total = total
        self.perPage = perPage
        self.currentPage = currentPage
        self.lastPage = lastPage
        self.activities = activities
    }
    
    static func fromJSON(_ json: JSONDictionary) -> ActivityResults {
        let json = JSON(json)
        
        let jsonResults = json["Results"]
        
        let total = jsonResults["Total"].int64Value
        let perPage = jsonResults["PerPage"].int64Value
        let currentPage = jsonResults["CurrentPage"].int64Value
        let lastPage = jsonResults["LastPage"].int64Value
        let activities = jsonResults["Activities"].arrayValue.map{ Activity.fromJSON($0) }
        
        return ActivityResults(total: total, perPage: perPage, currentPage: currentPage, lastPage: lastPage, activities: activities)
    }
}

final public class Activity {
    public let type: String
    public let verb: String
    public let actor: ActivityEntity?
    public let object: ActivityEntity?
    public let target: ActivityEntity?
    public let published: String
    
    public init(type: String, verb: String, published: String, actor: ActivityEntity?, object: ActivityEntity?, target: ActivityEntity?) {
        self.type = type
        self.verb = verb
        self.published = published
        self.actor = actor
        self.object = object
        self.target = target
    }
    
    static func fromJSON(_ json: JSON) -> Activity {
        let type = json["Type"].stringValue
        let verb = json["Verb"].stringValue
        let actor = ActivityEntity.fromJSON(json["Actor"])
        let object = ActivityEntity.fromJSON(json["Object"])
        let target = ActivityEntity.fromJSON(json["Target"])
        let published = json["Published"].stringValue
        
        return Activity(type: type, verb: verb, published: published, actor: actor, object: object, target: target)
    }
}

final public class ActivityEntity {
    public let id: Int64
    public let type: String
    public let displayName: String
    
    public init(id: Int64, type: String, displayName: String) {
        self.id = id
        self.type = type
        self.displayName = displayName
    }
    
    static func fromJSON(_ json: JSON) -> ActivityEntity {
        
        let id = json["Id"].int64Value
        let type = json["Type"].stringValue
        let displayName = json["DisplayName"].stringValue
        
        return ActivityEntity(id: id, type: type, displayName: displayName)
    }
}
