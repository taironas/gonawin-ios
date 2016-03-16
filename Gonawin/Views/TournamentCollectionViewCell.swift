//
//  TournamentCollectionViewCell.swift
//  Gonawin
//
//  Created by Remy JOURDE on 11/03/2016.
//  Copyright © 2016 Taironas. All rights reserved.
//

import UIKit
import GonawinEngine

class TournamentCollectionViewCell: UICollectionViewCell {
    
    var tournament: Tournament? {
        didSet {
            updateUI()
        }
    }
    @IBOutlet weak var tournamentImageView: UIWebView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var participantsCountLabel: UILabel!
    @IBOutlet weak var teamsCountLabel: UILabel!
    
    func updateUI() {
        //reset any existing activity information
        nameLabel?.text = nil
        participantsCountLabel?.text = nil
        teamsCountLabel?.text = nil
        
        //load new information from our activity
        if let tournament = self.tournament {
            let url = NSURL(string: tournament.imageURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!
            tournamentImageView.loadRequest(NSURLRequest(URL: url))
            
            nameLabel.text = tournament.name
            participantsCountLabel.text = "\(tournament.participantsCount)"
            teamsCountLabel.text = "\(tournament.teamsCount)"
        }
    }
}
