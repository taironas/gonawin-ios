//
//  TwitterLogin.swift
//  Gonawin
//
//  Created by Remy JOURDE on 21/03/2015.
//  Copyright (c) 2015 Taironas. All rights reserved.
//

import Accounts
import Social
import LVTwitterOAuthClient

class TwitterLogin {
    
    func login(completion: UserInfoCompletionHandler) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
            granted, error in
            if granted {
                let accountArray = accountStore.accountsWithAccountType(accountType)
                
                if accountArray.count > 0 {
                    if let twitterAccount = accountArray[0] as? ACAccount {
                        self.userInfo(twitterAccount) {
                            userInfo, error in
                            completion(userInfo: userInfo, error: nil)
                        }
                    }
                }
                else {
                    let error = NSError(domain: "com.taironas.gonawin", code: 0, userInfo: ["Error": "No Twitter account has been found"])
                    completion(userInfo: nil, error: error)
                }
            }
            else {
                completion(userInfo: nil, error: error)
            }
        }
    }
    
    private func userInfo(account: ACAccount, completion: UserInfoCompletionHandler ) {
        let url = NSURL(string: "https://api.twitter.com/1.1/users/show.json?screen_name=\(account.username)")!
        
        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
        
        request.account = account
        
        request.performRequestWithHandler() {
            data, response, error in
            if data != nil {
                let userInfoDico = decodeJSON(data)
                
                let id = userInfoDico!["id_str"] as! String
                let name = userInfoDico!["name"] as! String
                
                self.oauthToken(account) {
                    oauthToken, error in
                    if oauthToken != nil {
                        completion(userInfo: UserInfo(accessToken: oauthToken!, id: Int(id)!, email: "", name: name), error: nil)
                    }
                    else {
                        completion(userInfo: nil, error: error)
                    }
                }
            }
            else {
                completion(userInfo: nil, error: error)
            }
        }
    }
    
    private func oauthToken(account: ACAccount, completion: (oauthToken: String?, error: NSError?) -> Void) {
        let client = LVTwitterOAuthClient(consumerKey: twitterConsumerKey(), andConsumerSecret: twitterConsumerSecret())
        
        client.requestTokensForAccount(account) {
            oauthResponse, error in
            let oauthToken = oauthResponse[kLVOAuthAccessTokenKey] as! String?
            
            completion(oauthToken: oauthToken, error: error)
        }
    }
    
    private func twitterConsumerKey() -> String {
        let apiKeysPath = NSBundle.mainBundle().pathForResource("APIKeys", ofType: "plist")
        let keys = NSDictionary(contentsOfFile: apiKeysPath!)
        let FacebookAppID = keys!["TwitterConsumerKey"] as! String
        
        return FacebookAppID
    }
    
    private func twitterConsumerSecret() -> String {
        let apiKeysPath = NSBundle.mainBundle().pathForResource("APIKeys", ofType: "plist")
        let keys = NSDictionary(contentsOfFile: apiKeysPath!)
        let FacebookAppID = keys!["TwitterConsumerSecret"] as! String
        
        return FacebookAppID
    }
}