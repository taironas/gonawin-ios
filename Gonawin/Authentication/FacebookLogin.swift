//
//  FacebookLogin.swift
//  Gonawin
//
//  Created by Remy JOURDE on 21/03/2015.
//  Copyright (c) 2015 Taironas. All rights reserved.
//

import Accounts
import Social

class FacebookLogin {
    
    func login(completion: UserInfoCompletionHandler) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook)
        let accountOptions = [ACFacebookAppIdKey: facebookAppID(), ACFacebookPermissionsKey: ["email"]]
        
        var userInfo: UserInfo?
        
        accountStore.requestAccessToAccountsWithType(accountType, options: accountOptions as [NSObject : AnyObject]) {
            granted, error in
            if granted {
                let accountArray = accountStore.accountsWithAccountType(accountType)
                
                if accountArray.count > 0 {
                    if let facebookAccount = accountArray[0] as? ACAccount {
                        self.userInfo(facebookAccount) {
                            userInfo, error in
                            completion(userInfo: userInfo, error: nil)
                        }
                    }
                }
            }
            else {
                completion(userInfo: nil, error: error)
            }
        }
    }
    
    private func userInfo(account: ACAccount, completion: UserInfoCompletionHandler ) {
        let url = NSURL(string: "https://graph.facebook.com/v2.2/me")!
        
        let request = SLRequest(forServiceType: SLServiceTypeFacebook, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
        
        request.account = account
        
        request.performRequestWithHandler() {
            data, response, error in
            if data != nil {
                let jsonData: JSON! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil)
                let userInfoDico = _JSONObject(jsonData)
                
                let id = userInfoDico!["id"] as! String
                let email = userInfoDico!["email"] as! String
                let name = userInfoDico!["name"] as! String
                
                completion(userInfo: UserInfo(accessToken: account.credential.oauthToken, id: id.toInt()!, email: email, name: name), error: nil)
            }
            else {
                completion(userInfo: nil, error: error)
            }
        }
    }
    
    private func facebookAppID() -> String {
        let apiKeysPath = NSBundle.mainBundle().pathForResource("APIKeys", ofType: "plist")
        let keys = NSDictionary(contentsOfFile: apiKeysPath!)
        let FacebookAppID = keys!["FacebookAppID"] as! String
    
        return FacebookAppID
    }
}