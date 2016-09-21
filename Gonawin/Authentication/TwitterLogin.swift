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
    
    func login(_ completion: @escaping UserInfoCompletionHandler) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccounts(with: accountType, options: nil) {
            granted, error in
            if granted {
                let accountArray = accountStore.accounts(with: accountType)
                
                if (accountArray?.count)! > 0 {
                    if let twitterAccount = accountArray?[0] as? ACAccount {
                        self.userInfo(twitterAccount) {
                            userInfo, error in
                            completion(userInfo, nil)
                        }
                    }
                }
                else {
                    let error = NSError(domain: "com.taironas.gonawin", code: 0, userInfo: ["Error": "No Twitter account has been found"])
                    completion(nil, error)
                }
            }
            else {
                completion(nil, error as NSError?)
            }
        }
    }
    
    fileprivate func userInfo(_ account: ACAccount, completion: @escaping UserInfoCompletionHandler ) {
        let url = URL(string: "https://api.twitter.com/1.1/users/show.json?screen_name=\(account.username)")!
        
        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, url: url, parameters: nil)
        
        request?.account = account
        
        request?.perform() {
            data, response, error in
            if data != nil {
                let userInfoDico = decodeJSON(data!)
                
                let id = userInfoDico!["id_str"] as! String
                let name = userInfoDico!["name"] as! String
                
                self.oauthToken(account) {
                    oauthToken, error in
                    if oauthToken != nil {
                        completion(UserInfo(accessToken: oauthToken!, id: Int(id)!, email: "", name: name), nil)
                    }
                    else {
                        completion(nil, error)
                    }
                }
            }
            else {
                completion(nil, error as NSError?)
            }
        }
    }
    
    fileprivate func oauthToken(_ account: ACAccount, completion: @escaping (_ oauthToken: String?, _ error: NSError?) -> Void) {
        let client = LVTwitterOAuthClient(consumerKey: twitterConsumerKey(), andConsumerSecret: twitterConsumerSecret())
        
        client?.requestTokens(for: account) {
            oauthResponse, error in
            let oauthToken = oauthResponse?[kLVOAuthAccessTokenKey] as! String?
            
            completion(oauthToken, error as NSError?)
        }
    }
    
    fileprivate func twitterConsumerKey() -> String {
        let apiKeysPath = Bundle.main.path(forResource: "APIKeys", ofType: "plist")
        let keys = NSDictionary(contentsOfFile: apiKeysPath!)
        let FacebookAppID = keys!["TwitterConsumerKey"] as! String
        
        return FacebookAppID
    }
    
    fileprivate func twitterConsumerSecret() -> String {
        let apiKeysPath = Bundle.main.path(forResource: "APIKeys", ofType: "plist")
        let keys = NSDictionary(contentsOfFile: apiKeysPath!)
        let FacebookAppID = keys!["TwitterConsumerSecret"] as! String
        
        return FacebookAppID
    }
}
