//
//  LoginViewController.swift
//  Gonawin
//
//  Created by Remy JOURDE on 14/08/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import UIKit
import Accounts
import GonawinEngine
import RxSwift
import SwiftyUserDefaults
import Locksmith

class LoginViewController: UIViewController {
    
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var twitterLoginButton: UIButton!
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate let provider = GonawinEngine.newGonawinEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookLoginButton.layer.cornerRadius = 5.0
        twitterLoginButton.layer.cornerRadius = 5.0
    }
    
    @IBAction func Facebooklogin() {
        let facebookLogin = FacebookLogin()
        
        facebookLogin.login() {
            userInfo, error in
            if userInfo != nil {
                
                let authData = AuthData(accessToken: userInfo!.accessToken, provider: "facebook", id: userInfo!.id, email: userInfo!.email, name: userInfo!.name)
                
                self.provider.authenticate(authData)
                    .debug()
                    .catchError({ error in
                        print("error : \(error)")
                        return Observable.empty()
                    })
                    .subscribe(onNext: {
                        GonawinSession.session.newSession($0)
                        
                        self.dismiss(animated: true, completion: nil)
                    })
                    .addDisposableTo(self.disposeBag)
            }
            
            if error != nil {
                showError(error!, from: self)
            }
        }

    }
    
    @IBAction func Twiterlogin() {
        let twitterLogin = TwitterLogin()

        twitterLogin.login {
            userInfo, error in
            if userInfo != nil {
                let authData = AuthData(accessToken: userInfo!.accessToken, provider: "twitter", id: userInfo!.id, email: userInfo!.email, name: userInfo!.name)
                
                GonawinEngine.newGonawinEngine().authenticate(authData)
                    .catchError({ error in
                        print("error : \(error)")
                        return Observable.empty()
                    })
                    .subscribe(onNext: {
                        GonawinSession.session.newSession($0)
                        
                        self.dismiss(animated: true, completion: nil)
                    })
                    .addDisposableTo(self.disposeBag)
            }
            
            if error != nil {
                showError(error!, from: self)
            }
        }
        
    }
}
