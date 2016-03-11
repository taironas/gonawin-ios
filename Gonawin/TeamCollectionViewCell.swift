//
//  TeamCollectionViewCell.swift
//  Gonawin
//
//  Created by Remy JOURDE on 09/03/2016.
//  Copyright © 2016 Taironas. All rights reserved.
//

import UIKit
import GonawinEngine
import SDWebImage

class TeamCollectionViewCell: UICollectionViewCell {
    
    var team: Team? {
        didSet {
            updateUI()
        }
    }
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var membersCountLabel: UILabel!
    
    override func layoutSubviews() {
        let imageLayer = teamImageView.layer
        imageLayer.cornerRadius = teamImageView.frame.size.height/2
        imageLayer.masksToBounds = true
    }
    
    func updateUI() {
        //reset any existing activity information
        nameLabel?.text = nil
        membersCountLabel?.text = nil
        
        //load new information from our activity
        if let team = self.team {
            let url = NSURL(string: team.imageURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!
            teamImageView.sd_setImageWithURL(url)
            
            nameLabel.text = team.name
            membersCountLabel.text = "\(team.membersCount)"
        }
    }
}