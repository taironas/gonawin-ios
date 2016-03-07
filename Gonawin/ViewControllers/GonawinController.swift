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
        
        // load session
        GonawinSession.session
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // check if user is already logged in
        if !GonawinSession.session.isLoggedIn() {
            self.performSegueWithIdentifier("showLogin", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
