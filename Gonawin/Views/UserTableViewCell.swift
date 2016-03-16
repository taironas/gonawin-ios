//
//  UserTableViewCell.swift

//  Gonawin
//
//  Created by Remy JOURDE on 13/03/2016.
//  Copyright © 2016 Taironas. All rights reserved.
//

import UIKit
import GonawinEngine

class UserTableViewCell: UITableViewCell {
    
    var user: User? {
        didSet {
            updateUI()
        }
    }

    @IBOutlet weak var userImageView: UIWebView!
    @IBOutlet weak var userNamelabel: UILabel!
    @IBOutlet weak var userScoreLabel: UILabel!
    
    override func layoutSubviews() {
        let imageLayer = userImageView.layer
        imageLayer.cornerRadius = userImageView.frame.size.height/2
        imageLayer.masksToBounds = true
    }

    func updateUI() {
        //reset any existing activity information
        userNamelabel?.text = nil
        userScoreLabel?.text = nil
        
        //load new information from our user
        if let user = self.user {
            let url = NSURL(string: (user.imageURL + "&size=150").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!
            userImageView.loadRequest(NSURLRequest(URL: url))
            
            userNamelabel.text = user.username
            userScoreLabel.text = "\(user.score)"
        }
    }
}