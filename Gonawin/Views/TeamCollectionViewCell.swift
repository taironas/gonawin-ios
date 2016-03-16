//
//  TeamCollectionViewCell.swift
//  Gonawin
//
//  Created by Remy JOURDE on 09/03/2016.
//  Copyright © 2016 Taironas. All rights reserved.
//

import UIKit
import GonawinEngine

class TeamCollectionViewCell: UICollectionViewCell {
    
    var team: Team? {
        didSet {
            updateUI()
        }
    }
    @IBOutlet weak var teamImageView: UIWebView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var membersCountLabel: UILabel!
    
    func updateUI() {
        //reset any existing activity information
        nameLabel?.text = nil
        membersCountLabel?.text = nil
        
        //load new information from our activity
        if let team = self.team {
            let url = NSURL(string: team.imageURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!
            teamImageView.loadRequest(NSURLRequest(URL: url))
            
            nameLabel.text = team.name
            membersCountLabel.text = "\(team.membersCount)"
        }
    }
}