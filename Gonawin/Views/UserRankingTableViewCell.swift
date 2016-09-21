//
//  UserRankingTableViewCell.swift
//  Gonawin
//
//  Created by Remy JOURDE on 14/03/2016.
//  Copyright © 2016 Taironas. All rights reserved.
//

import UIKit

class UserRankingTableViewCell: UserTableViewCell {

    @IBOutlet weak var rankinglabel: UILabel!
    
    override func layoutSubviews() {
        let imageLayer = userImageView.layer
        imageLayer.cornerRadius = userImageView.frame.size.height/2
        imageLayer.masksToBounds = true
    }
    
    override func updateUI() {
        //reset any existing activity information
        userNamelabel?.text = nil
        userScoreLabel?.text = nil
        
        //load new information from our user
        if let user = self.user {
            let url = URL(string: (user.imageURL + "&size=150").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            userImageView.loadRequest(URLRequest(url: url))
            
            userNamelabel.text = user.username
            userScoreLabel.text = "\(user.score)"
        }
    }

}
