//
//  GonawinSession.swift
//  Gonawin
//
//  Created by Remy JOURDE on 04/03/2016.
//  Copyright © 2016 Taironas. All rights reserved.
//

import GonawinEngine
import SwiftyUserDefaults
import Locksmith

class GonawinSession {
    var authorizationToken: String?
    var currentUser: User?
    
    static let session = GonawinSession()
    
    private init() {
        if let data = Locksmith.loadDataForUserAccount("GonawinClient") {
            authorizationToken = data["auth"] as? String
            
            // TODO: fetch current user
        }
    }
    
    func newSession(user: User) {
        authorizationToken = user.auth
        // save access token in keychain
        do {
            try Locksmith.saveData(["auth": user.auth], forUserAccount: "GonawinClient")
        }
        catch {
            print("error :  cannot add the auth token into the keychain")
        }
    }
    
    func deleteSession() {
        // delete auth token in keychain
        do {
            try Locksmith.deleteDataForUserAccount("GonawinClient")
        }
        catch {
            print("Error when trying to delete the auth token in keychain")
        }
        
    }
    
    func isLoggedIn() -> Bool {
        return (authorizationToken != nil)
    }
}
