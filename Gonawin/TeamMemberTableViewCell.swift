//
//  TeamMemberTableViewCell.swift

//  Gonawin
//
//  Created by Remy JOURDE on 13/03/2016.
//  Copyright © 2016 Taironas. All rights reserved.
//

import UIKit
import GonawinEngine

class TeamMemberTableViewCell: UITableViewCell {
    
    var member: User? {
        didSet {
            updateUI()
        }
    }

    @IBOutlet weak var teamImageView: UIWebView!
    @IBOutlet weak var teamTitlelabel: UILabel!
    @IBOutlet weak var teamSubtitleLabel: UILabel!
    
    override func layoutSubviews() {
        let imageLayer = teamImageView.layer
        imageLayer.cornerRadius = teamImageView.frame.size.height/2
        imageLayer.masksToBounds = true
    }

    func updateUI() {
        //reset any existing activity information
        teamTitlelabel?.text = nil
        teamSubtitleLabel?.text = nil
        
        //load new information from our user
        if let member = self.member {
            let url = NSURL(string: (member.imageURL + "&size=170").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!
            teamImageView.loadRequest(NSURLRequest(URL: url))
            
            teamTitlelabel.text = member.username
            teamSubtitleLabel.text = "\(member.score)"
        }
    }
}
