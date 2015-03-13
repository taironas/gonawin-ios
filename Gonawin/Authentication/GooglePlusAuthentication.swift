//
//  GooglePlusAuthentication.swift
//  Gonawin
//
//  Created by Remy JOURDE on 13/02/2015.
//  Copyright (c) 2015 Taironas. All rights reserved.
//

import UIKit
import OAuth2

class GooglePlusAuthentication {
    class var sharedInstance: GooglePlusAuthentication {
        struct Static {
            static let instance = GooglePlusAuthentication()
        }
        return Static.instance
    }
    
    let apiKeysPath = NSBundle.mainBundle().pathForResource("APIKeys", ofType: "plist")
    let baseURL = NSURL(string: "https://graph.facebook.com")!
    var accessToken = ""
    
    var oauth2: OAuth2CodeGrant
    
    init() {
        let keys = NSDictionary(contentsOfFile: apiKeysPath!)
        let GPKeys = keys!["GooglePlus"] as! [String:String]
        
        oauth2 = OAuth2CodeGrant(settings: [
            "client_id": GPKeys["client_id"]!,
            "authorize_uri": "https://accounts.google.com/o/oauth2/auth",
            "token_uri": "https://accounts.google.com/o/oauth2/token",
            "scope": "https://www.googleapis.com/auth/plus.login https://www.googleapis.com/auth/userinfo.email",
            "redirect_uris": ["http://localhost/"],
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
    
    /** Perform a request against the Google Plus and return decoded JSON or an NSError. */
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
}
