//
//  TeamTableViewCell.swift
//  Gonawin
//
//  Created by Remy JOURDE on 15/03/2016.
//  Copyright © 2016 Taironas. All rights reserved.
//

import UIKit
import GonawinEngine

class TeamTableViewCell: UITableViewCell {
    
    var team: Team? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var teamImageView: UIWebView!
    @IBOutlet weak var teamNamelabel: UILabel!
    @IBOutlet weak var teamMembersCountLabel: UILabel!
    
    func updateUI() {
        //reset any existing activity information
        teamNamelabel?.text = nil
        teamMembersCountLabel?.text = nil
        
        //load new information from our user
        if let team = self.team {
            let url = URL(string: (team.imageURL + "&size=140").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            teamImageView.loadRequest(URLRequest(url: url))
            
            teamNamelabel.text = team.name
            teamMembersCountLabel.text = "\(team.membersCount)"
        }
    }
}
