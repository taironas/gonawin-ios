//
//  FacebookAuthentication.swift
//  Gonawin
//
//  Created by Remy JOURDE on 01/02/2015.
//  Copyright (c) 2015 Taironas. All rights reserved.
//

import UIKit
import OAuth2

class FacebookAuthentication {
    class var sharedInstance: FacebookAuthentication {
        struct Static {
            static let instance = FacebookAuthentication()
        }
        return Static.instance
    }
    
    let baseURL = NSURL(string: "https://graph.facebook.com")!
    var accessToken = ""
    
    var oauth2: OAuth2CodeGrantFacebook
    
    init() {
        let apiKeysPath = NSBundle.mainBundle().pathForResource("APIKeys", ofType: "plist")
        let keys = NSDictionary(contentsOfFile: apiKeysPath!)
        let FBKeys = keys!["Facebook"] as [String:String]
        
        oauth2 = OAuth2CodeGrantFacebook(settings: [
            "client_id": FBKeys["client_id"]!,
            "client_secret": FBKeys["client_secret"]!,
            "authorize_uri": "https://graph.facebook.com/oauth/authorize",
            "token_uri": "https://graph.facebook.com/oauth/access_token",
            "scope": "email",
            "redirect_uris": ["http://gonawin.com/auth"],
            ])
    }
    
    /** Start the OAuth dance. */
    func authorize(controller: UIViewController, callback: (wasFailure: Bool, error: NSError?) -> Void) {
        let web = oauth2.authorizeEmbeddedFrom(controller, params: nil)
        oauth2.afterAuthorizeOrFailure = { wasFailure, error in
            web.dismissViewControllerAnimated(true, completion: nil)
            self.accessToken = self.oauth2.accessToken
            callback(wasFailure: wasFailure, error: error)
        }
    }
    
    /** Perform a request against the Facebook API and return decoded JSON or an NSError. */
    func request(path: String, callback: ((dict: NSDictionary?, error: NSError?) -> Void)) {
        let url = baseURL.URLByAppendingPathComponent(path)
        let req = oauth2.request(forURL: url)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(req) { data, response, error in
            if nil != error {
                dispatch_async(dispatch_get_main_queue(), {
                    callback(dict: nil, error: error)
                })
            }
            else {
                var err: NSError?
                let dict = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as? NSDictionary
                dispatch_async(dispatch_get_main_queue(), {
                    callback(dict: dict, error: err)
                })
            }
        }
        task.resume()
    }
    
    func userInfo(result: (Result<FBUserInfo>) -> ())
    {
        let url = baseURL.URLByAppendingPathComponent("/v2.2/me")
        let req = oauth2.request(forURL: url)
        
        performRequest(req, result)
    }
}
