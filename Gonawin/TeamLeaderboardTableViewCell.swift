//
//  TeamLeaderboardTableViewCell.swift
//  Gonawin
//
//  Created by Remy JOURDE on 14/03/2016.
//  Copyright © 2016 Taironas. All rights reserved.
//

import UIKit

class TeamLeaderboardTableViewCell: TeamMemberTableViewCell {

    @IBOutlet weak var teamRankinglabel: UILabel!
    
    override func layoutSubviews() {
        let imageLayer = teamImageView.layer
        imageLayer.cornerRadius = teamImageView.frame.size.height/2
        imageLayer.masksToBounds = true
    }
    
    override func updateUI() {
        //reset any existing activity information
        teamTitlelabel?.text = nil
        teamSubtitleLabel?.text = nil
        
        //load new information from our user
        if let member = self.member {
            let url = NSURL(string: (member.imageURL + "&size=150").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!
            teamImageView.loadRequest(NSURLRequest(URL: url))
            
            teamTitlelabel.text = member.username
            teamSubtitleLabel.text = "\(member.score)"
        }
    }

}
