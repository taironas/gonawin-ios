//
//  GonawinClient.swift
//  Gonawin
//
//  Created by Remy JOURDE on 20/09/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import UIKit
import Alamofire

protocol GonawinAPIDelegate {
    func didAuthenticatedWithAccessToken(accessToken: String, user: User)
    func didFailToAuthenticateWithError(error: NSError)
    func didLogout()
}

class GonawinAPI {
    var currentUser: User?
    var accessToken: String?
    
    var delegate: GonawinAPIDelegate?
    
    class var sharedInstance : GonawinAPI {
        
        struct Static {
            static let instance : GonawinAPI = GonawinAPI()
        }
        
        return Static.instance
    }
    
    init() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let userData = userDefaults.objectForKey("CurrentUser") as NSData? {
            let userDico: Dictionary<String, AnyObject> = NSKeyedUnarchiver.unarchiveObjectWithData(userData) as Dictionary<String, AnyObject>
            self.currentUser = User.decode(userDico)
            
            self.accessToken = KeychainService.loadAccessToken()
        }
    }
    
    // MARK: - Gonawin API
    
    func login(accessToken: String, provider: String, id: Int, email: String, name: String) {
        
        let authParams = ["access_token": accessToken, "provider": provider, "id": id.description, "email": email, "name": name]
        Alamofire.request(.GET, "http://www.gonawin.com/j/auth/", parameters: authParams)
            .response { (request, response, data, error) in
                let result: Result<User>  = parseResult(data as NSData, response, error)
                
                switch result {
                case let .Error(error):
                    self.delegate?.didFailToAuthenticateWithError(error)
                case let .Value(boxedUser):
                    self.currentUser = boxedUser.value
                    self.accessToken = accessToken
                    self.delegate?.didAuthenticatedWithAccessToken(accessToken, user: boxedUser.value)
                }
            }
    }
    
    func user(userId: Int) {
        Alamofire.request(.GET, "http://www.gonawin.com/j/users/", parameters: ["id": userId])
            .response { (request, response, data, error) in
                println("userDetails response = \(response)")
        }
    }
    
    func logout()
    {
        currentUser = nil
        accessToken = nil
        
        self.delegate?.didLogout()
    }
    
    // MARK: - Private
    
    func isLoggedIn() -> Bool {
        return (currentUser != nil && accessToken?.isEmpty != nil)
    }
}
