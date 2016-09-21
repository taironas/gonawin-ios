//
//  AppDelegate.swift
//  Gonawin
//
//  Created by Remy JOURDE on 11/08/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GonawinSessionDelegate {
                            
    var window: UIWindow?
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let authenticationStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
    
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        let navigationBarAppearance = UINavigationBar.appearance()
        
        navigationBarAppearance.barTintColor = UIColor.white
        navigationBarAppearance.tintColor = UIColor.greenSeaFoam
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.darkBlue]
        navigationBarAppearance.isTranslucent = false
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.greenSeaFoam], for: .selected)
        
        GonawinSession.session.delegate = self
        
        // check if user is already logged in
        if !GonawinSession.session.isLoggedIn() {
            self.window?.rootViewController = authenticationStoryboard.instantiateInitialViewController()
        }
        else {
            self.window?.rootViewController = mainStoryboard.instantiateInitialViewController()
        }
    }
    
    func didLogin() {
        self.window?.rootViewController = mainStoryboard.instantiateInitialViewController()
    }
    func didLogout() {
        self.window?.rootViewController = authenticationStoryboard.instantiateInitialViewController()
    }
}

