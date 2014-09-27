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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // check if user is already logged in
        if !GonawinClient.sharedInstance.isLoggedIn() {
            if let loginViewController: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as? UIViewController {
                self.presentViewController(loginViewController, animated: false, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
