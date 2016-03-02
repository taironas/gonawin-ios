//
//  GonawinController
//  Gonawin
//
//  Created by Remy JOURDE on 15/09/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import UIKit
import Locksmith

class GonawinController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //TODO: Show Login view if user is not logged in
        // check if user is already logged in
        if true {
            self.performSegueWithIdentifier("showLogin", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didAuthenticatedWithUser(user: User)
    {
        // save access token in keychain
        do {
            try Locksmith.saveData(["auth": user.auth], forUserAccount: "GonawinClient")
        }
        catch {
            print("Error when trying to add the auth token in keychain")
        }
        // store user in NSUserDefaults
        let data = NSKeyedArchiver.archivedDataWithRootObject(user.encoded())
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "CurrentUser")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didFailToAuthenticateWithError(error: NSError) {
        // inform user that something wrong happened
        print(error)
    }
    
    func didLogoutWithAccessToken(authToken: String) {
        // delete auth token in keychain
        do {
            try Locksmith.deleteDataForUserAccount("GonawinClient")
        }
        catch {
            print("Error when trying to delete the auth token in keychain")
        }
        // delete user in NSUserDefaults
        NSUserDefaults.standardUserDefaults().removeObjectForKey("CurrentUser")
        
        self.performSegueWithIdentifier("showLogin", sender: self)
    }
}
