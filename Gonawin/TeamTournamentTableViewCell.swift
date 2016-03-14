//
//  TeamTournamentTableViewCell.swift
//  Gonawin
//
//  Created by Remy JOURDE on 13/03/2016.
//  Copyright © 2016 Taironas. All rights reserved.
//

import UIKit
import GonawinEngine

class TeamTournamentTableViewCell: TeamMemberTableViewCell {

    var tournament: Tournament? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var teamSubtitle2label: UILabel!

    override func updateUI() {
        //reset any existing activity information
        teamTitlelabel?.text = nil
        teamSubtitleLabel?.text = nil
        teamSubtitle2label?.text = nil
        
        //load new information from our user
        if let tournament = self.tournament {
            let url = NSURL(string: (tournament.imageURL + "&size=150").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!
            teamImageView.loadRequest(NSURLRequest(URL: url))
            
            teamTitlelabel.text = tournament.name
            teamSubtitleLabel.text = "\(tournament.participantsCount)"
            teamSubtitle2label.text = "\(tournament.teamsCount)"
        }
    }
}
