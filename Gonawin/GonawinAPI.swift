//
//  GonawinClient.swift
//  Gonawin
//
//  Created by Remy JOURDE on 20/09/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import Alamofire

protocol GonawinAPIDelegate {
    func didAuthenticatedWithUser(user: User)
    func didFailToAuthenticateWithError(error: NSError)
    func didLogoutWithAccessToken(accessToken: String)
}

class GonawinAPI {
    var currentUser: User?
    
    var delegate: GonawinAPIDelegate?
    
    static let client = GonawinAPI()
    
    init() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let userData = userDefaults.objectForKey("CurrentUser") as? NSData {
            let userDico: [String:AnyObject] = NSKeyedUnarchiver.unarchiveObjectWithData(userData) as! [String: AnyObject]
            self.currentUser = parseUser(userDico)
            
            if let authToken = KeychainService.loadAccessToken() {
                currentUser?.auth = authToken
            }
        }
    }
    
    // MARK: - Gonawin API
    
    func login(accessToken: String, provider: String, id: Int, email: String, name: String) {
        Alamofire.request(Router.Auth(accessToken: accessToken, provider: provider, id: id.description, email: email, name: name)).response {
            _, response, data, error in
            if let dico = decodeJSON(data as! NSData), user = parseUser(dico["User"] as! JSONDictionary), authToken = getAuthToken(dico["User"] as! JSONDictionary) {
                self.currentUser = user
                self.currentUser?.auth = authToken
                self.delegate?.didAuthenticatedWithUser(self.currentUser!)
            }
            else if error != nil {
                self.delegate?.didFailToAuthenticateWithError(error!)
            }
        }
    }

    func activites(page: Int, count: Int, completion: (activities: [Activity], error: NSError?) -> Void) {
        Router.authToken = currentUser?.auth
        
        var activities: [Activity] = []
        
        Alamofire.request(Router.Activities(page: page, count: count)).response {
            _, response, data, error in
            if let array = decodeJSONArray(data as! NSData) {
                for jsonActivity in array {
                    if let activity = parseActivity(jsonActivity) {
                        activities.append(activity)
                    }
                }
            }
            
            completion(activities: activities, error: nil)
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
        if let authToken = currentUser?.auth {
            self.delegate?.didLogoutWithAccessToken(authToken)
        }
        
        currentUser = nil
    }
    
    // MARK: - Private
    
    func isLoggedIn() -> Bool {
        return (currentUser != nil)
    }
}
