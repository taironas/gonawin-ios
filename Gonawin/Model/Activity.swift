//
//  Activity.swift
//  Gonawin
//
//  Created by Remy JOURDE on 29/03/2015.
//  Copyright (c) 2015 Taironas. All rights reserved.
//

struct Activity {
    var type: String
    var verb: String
    var actor: ActivityEntity?
    var object: ActivityEntity?
    var target: ActivityEntity?
    var published: String
}

struct ActivityEntity {
    var id: Int
    var type: String
    var displayName: String
}

func parseActivity(dict: JSONDictionary) -> Activity? {
    var activity: Activity?
    if let
        type        = dict["Type"] as? String,
        verb        = dict["Verb"] as? String,
        published   = dict["Published"] as? String
    {
        activity = Activity(type: type, verb: verb, actor: nil, object: nil, target: nil, published: published)
        
        if let actorDict = dict["Actor"] as? JSONDictionary {
            activity?.actor = parseActivityEntity(actorDict)
        }
        
        if let objectDict = dict["Object"] as? JSONDictionary {
            activity?.object = parseActivityEntity(objectDict)
        }
        
        if let targetDict = dict["Target"] as? JSONDictionary {
            activity?.target = parseActivityEntity(targetDict)
        }
    }
    
    return activity
}

func parseActivityEntity(dict: JSONDictionary) -> ActivityEntity? {
    var activityEntity: ActivityEntity?
    if let
        id = dict["Id"] as? Int,
        type = dict["Type"] as? String,
        displayName = dict["DisplayName"] as? String
    {
        activityEntity = ActivityEntity(id: id, type: type, displayName: displayName)
    }
    
    return activityEntity
}

