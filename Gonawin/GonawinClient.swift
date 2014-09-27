//
//  GonawinClient.swift
//  Gonawin
//
//  Created by Remy JOURDE on 20/09/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import UIKit
import Alamofire

protocol GonawinClientDelegate {
    func didAuthenticatedWithAccessToken(accessToken: String, user: User)
    func didFailToAuthenticateWithError(error: NSError)
}

let googleProvider = "google"

class GonawinClient {
    var currentUser: User?
    var accessToken: String?
    var provider: String?
    
    var delegate: GonawinClientDelegate?
    
    class var sharedInstance : GonawinClient {
        
        struct Static {
            static let instance : GonawinClient = GonawinClient()
        }
        
        return Static.instance
    }
    
    func loginWithGooglePlus(accessToken: String, id: String, email: String, name: String) {
        
        let authParams = ["access_token": accessToken, "provider": googleProvider, "id": id, "email": email, "name": name]
        Alamofire.request(.GET, "http://www.gonawin.com/j/auth/", parameters: authParams)
            .response { (request, response, data, error) in
                let result: Result<User>  = parseData(data as NSData, response, error)
                
                switch result {
                case let .Error(error):
                    self.delegate?.didFailToAuthenticateWithError(error)
                case let .Value(boxedUser):
                    self.currentUser = boxedUser.value
                    self.accessToken = accessToken
                    self.provider = googleProvider
                    self.delegate?.didAuthenticatedWithAccessToken(accessToken, user: boxedUser.value)
                }
            }
    }
    
    init() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let provider = userDefaults.objectForKey("Provider") as? String {
            if isProviderValid(provider) {
                self.provider = provider
            }
        }
        
        let userData: NSData = userDefaults.objectForKey("CurrentUser") as NSData
        let userDico: Dictionary<String, AnyObject> = NSKeyedUnarchiver.unarchiveObjectWithData(userData) as Dictionary<String, AnyObject>
        self.currentUser = User.decode(userDico)
        
        self.accessToken = KeychainService.loadAccessToken()
    }
    
    func isLoggedIn() -> Bool {
        return (currentUser != nil && provider != nil && accessToken?.isEmpty != nil)
    }
    
    private func isProviderValid(provider: String) -> Bool {
        return (provider == googleProvider)
    }
}
