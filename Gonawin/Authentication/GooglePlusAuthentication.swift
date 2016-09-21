//
//  GooglePlusAuthentication.swift
//  Gonawin
//
//  Created by Remy JOURDE on 13/02/2015.
//  Copyright (c) 2015 Taironas. All rights reserved.
//

import UIKit
import p2_OAuth2

class GooglePlusAuthentication {
    class var sharedInstance: GooglePlusAuthentication {
        struct Static {
            static let instance = GooglePlusAuthentication()
        }
        return Static.instance
    }
    
    let apiKeysPath = Bundle.main.path(forResource: "APIKeys", ofType: "plist")
    let baseURL = URL(string: "https://graph.facebook.com")!
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
}
