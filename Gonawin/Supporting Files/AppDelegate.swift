//
//  AppDelegate.swift
//  Gonawin
//
//  Created by Remy JOURDE on 11/08/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    
    func applicationDidFinishLaunching(application: UIApplication) {
        let navigationBarAppearance = UINavigationBar.appearance()
        
        navigationBarAppearance.barTintColor = UIColor.whiteColor()
        navigationBarAppearance.tintColor = UIColor.greenSeaFoamColor()
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.darkBlueColor()]
        navigationBarAppearance.translucent = false
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.greenSeaFoamColor()], forState:.Selected)
    }
}

