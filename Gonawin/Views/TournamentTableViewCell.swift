//
//  TournamentTableViewCell.swift
//  Gonawin
//
//  Created by Remy JOURDE on 13/03/2016.
//  Copyright © 2016 Taironas. All rights reserved.
//

import UIKit
import GonawinEngine

class TournamentTableViewCell: UITableViewCell {

    var tournament: Tournament? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var tournamentImageView: UIWebView!
    @IBOutlet weak var tournamentNamelabel: UILabel!
    @IBOutlet weak var participantsCountLabel: UILabel!
    @IBOutlet weak var teamsCountlabel: UILabel!

    func updateUI() {
        //reset any existing activity information
        tournamentNamelabel?.text = nil
        participantsCountLabel?.text = nil
        teamsCountlabel?.text = nil
        
        //load new information from our user
        if let tournament = self.tournament {
            let url = NSURL(string: (tournament.imageURL + "&size=150").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!
            tournamentImageView.loadRequest(NSURLRequest(URL: url))
            
            tournamentNamelabel.text = tournament.name
            participantsCountLabel.text = "\(tournament.participantsCount)"
            teamsCountlabel.text = "\(tournament.teamsCount)"
        }
    }
}
