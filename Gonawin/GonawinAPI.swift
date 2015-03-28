//
//  GonawinClient.swift
//  Gonawin
//
//  Created by Remy JOURDE on 20/09/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import Alamofire

protocol GonawinAPIDelegate {
    func didAuthenticatedWithAccessToken(accessToken: String, user: User)
    func didFailToAuthenticateWithError(error: NSError)
    func didLogoutWithAccessToken(accessToken: String)
}

class GonawinAPI {
    var currentUser: User?
    var accessToken: String?
    
    var delegate: GonawinAPIDelegate?
    
    static let client = GonawinAPI()
    
    init() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let userData = userDefaults.objectForKey("CurrentUser") as? NSData {
            let userDico: [String:AnyObject] = NSKeyedUnarchiver.unarchiveObjectWithData(userData) as! [String: AnyObject]
            self.currentUser = User.decode(userDico)
            
            self.accessToken = KeychainService.loadAccessToken()
        }
    }
    
    // MARK: - Gonawin API
    
    func login(accessToken: String, provider: String, id: Int, email: String, name: String) {
        Alamofire.request(Router.Auth(accessToken: accessToken, provider: provider, id: id.description, email: email, name: name)).response {
            _, response, data, error in
            let result: Result<User> = parseResult(data as! NSData, response, error)
            
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
        Alamofire.request(Router.User(id: userId))
            .response { (request, response, data, error) in
                println("userDetails response = \(response)")
        }
    }
    
    func logout()
    {
        self.delegate?.didLogoutWithAccessToken(accessToken!)
        
        currentUser = nil
        accessToken = nil
    }
    
    // MARK: - Private
    
    func isLoggedIn() -> Bool {
        return (currentUser != nil && accessToken?.isEmpty != nil)
    }
}
