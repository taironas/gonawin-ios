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
import RxSwift

class GonawinSession {
    var authorizationToken: String?
    var currentUser: User?
    
    static let session = GonawinSession()
    
    private let disposeBag = DisposeBag()
    private var provider: AuthorizedGonawinEngine?
    
    private init() {
        if let data = Locksmith.loadDataForUserAccount("GonawinClient") {
            
            authorizationToken = data["auth"] as? String
            
            if let userID = Defaults[.currentUserID] {
                // fetch current user
                self.provider = GonawinEngine.newAuthorizedGonawinEngine(authorizationToken!)
                    
                self.provider!.getUser(userID)
                    .debug()
                    .catchError({ error in
                        print("error : \(error)")
                        return Observable.empty()
                    })
                    .subscribeNext {
                        self.currentUser = $0
                    }
                    .addDisposableTo(self.disposeBag)
            }
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
        
        // save user id in user defaults
        Defaults[.currentUserID] = Int(user.id)
    }
    
    func deleteSession() {
        // delete auth token in keychain
        do {
            try Locksmith.deleteDataForUserAccount("GonawinClient")
        }
        catch {
            print("Error when trying to delete the auth token in keychain")
        }
        
        // delete user id from user defaults
        Defaults.remove(.currentUserID)
    }
    
    func isLoggedIn() -> Bool {
        return (authorizationToken != nil)
    }
}
