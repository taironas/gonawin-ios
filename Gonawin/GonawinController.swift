//
//  GonawinController
//  Gonawin
//
//  Created by Remy JOURDE on 15/09/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import UIKit

class GonawinController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if isLoggedIn() {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            
            let accessToken: String = userDefaults.objectForKey("AccessToken") as String
            let provider: String = userDefaults.objectForKey("Provider") as String
            let userData: NSData = userDefaults.objectForKey("CurrentUser") as NSData
            let userDico: Dictionary<String, AnyObject> = NSKeyedUnarchiver.unarchiveObjectWithData(userData) as Dictionary<String, AnyObject>
            if let user = User.decode(userDico) {
                GonawinClient.sharedInstance.initWithAccessToken(accessToken, user: user, provider: provider)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // check if user is already logged in
        if !isLoggedIn() {
            if let loginViewController: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as? UIViewController {
                self.presentViewController(loginViewController, animated: false, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func isLoggedIn() -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        return (userDefaults.objectForKey("CurrentUser") != nil
            && userDefaults.objectForKey("AccessToken") != nil
            && userDefaults.objectForKey("Provider") != nil)
    }
}
