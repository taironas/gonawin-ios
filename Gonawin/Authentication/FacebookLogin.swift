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
    
    func login(_ completion: @escaping UserInfoCompletionHandler) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierFacebook)
        let accountOptions = [ACFacebookAppIdKey: facebookAppID(), ACFacebookPermissionsKey: ["email"]] as [String : Any]
        
        accountStore.requestAccessToAccounts(with: accountType, options: accountOptions as [AnyHashable: Any]) {
            granted, error in
            if granted {
                let accountArray = accountStore.accounts(with: accountType)
                
                if (accountArray?.count)! > 0 {
                    if let facebookAccount = accountArray?[0] as? ACAccount {
                        self.userInfo(facebookAccount) {
                            userInfo, error in
                            completion(userInfo, nil)
                        }
                    }
                }
                else {
                    let error = NSError(domain: "com.taironas.gonawin", code: 0, userInfo: ["Error": "No Facebook account has been found"])
                    completion(nil, error)
                }
            }
            else {
                completion(nil, error as NSError?)
            }
        }
    }
    
    fileprivate func userInfo(_ account: ACAccount, completion: @escaping UserInfoCompletionHandler ) {
        let url = URL(string: "https://graph.facebook.com/v2.2/me")!
        
        let request = SLRequest(forServiceType: SLServiceTypeFacebook, requestMethod: SLRequestMethod.GET, url: url, parameters: nil)
        
        request?.account = account
        
        request?.perform() {
            data, response, error in
            if data != nil {
                let userInfoDico = decodeJSON(data!)
                
                let id = userInfoDico!["id"] as! String
                let email = userInfoDico!["email"] as! String
                let name = userInfoDico!["name"] as! String
                
                completion(UserInfo(accessToken: account.credential.oauthToken, id: Int(id)!, email: email, name: name), nil)
            }
            else {
                completion(nil, error as NSError?)
            }
        }
    }
    
    fileprivate func facebookAppID() -> String {
        let apiKeysPath = Bundle.main.path(forResource: "APIKeys", ofType: "plist")
        let keys = NSDictionary(contentsOfFile: apiKeysPath!)
        let FacebookAppID = keys!["FacebookAppID"] as! String
    
        return FacebookAppID
    }
}
