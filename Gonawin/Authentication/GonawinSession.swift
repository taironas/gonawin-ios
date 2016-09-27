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

protocol GonawinSessionDelegate: class {
    func didLogin()
    func didLogout()
}
class GonawinSession {
    var authorizationToken: String?
    var currentUser: User?
    
    static let session = GonawinSession()
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate var provider: AuthorizedGonawinEngine?
    
    weak var delegate: GonawinSessionDelegate?
    
    fileprivate init() {
        if let data = Locksmith.loadDataForUserAccount(userAccount: "GonawinClient") {
            
            authorizationToken = data["auth"] as? String
            
            if let userID = Defaults[.currentUserID] {
                fetchCurrentUser(userID: userID)
            }
        }
    }
    
    func newSession(_ user: User) {
        authorizationToken = user.auth
        // save access token in keychain
        do {
            try Locksmith.saveData(data: ["auth": user.auth], forUserAccount: "GonawinClient")
        }
        catch {
            print("error :  cannot add the auth token into the keychain")
        }
        
        // save user id in user defaults
        Defaults[.currentUserID] = Int(user.id)
        
        fetchCurrentUser(userID: Int(user.id))
        
        delegate?.didLogin()
    }
    
    func deleteSession() {
        // delete auth token in keychain
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: "GonawinClient")
        }
        catch {
            print("Error when trying to delete the auth token in keychain")
        }
        
        // delete user id from user defaults
        Defaults.remove(.currentUserID)
        
        delegate?.didLogout()
    }
    
    func isLoggedIn() -> Bool {
        return (authorizationToken != nil)
    }
    
    fileprivate func fetchCurrentUser(userID: Int) {
    
        self.provider = GonawinEngine.newAuthorizedGonawinEngine(authorizationToken!)
        
        self.provider?.getUser(userID)
            .debug()
            .catchError({ error in
                print("error : \(error)")
                return Observable.empty()
            })
            .subscribe(onNext: {
                self.currentUser = $0
            })
            .addDisposableTo(self.disposeBag)
    }
}
