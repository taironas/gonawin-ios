//
//  MatchTableViewCell.swift
//  Gonawin
//
//  Created by Remy JOURDE on 17/03/2016.
//  Copyright © 2016 Taironas. All rights reserved.
//

import UIKit
import GonawinEngine

class MatchTableViewCell: UITableViewCell {

    var match: Match? {
        didSet {
            updateUI()
        }
    }

    @IBOutlet weak var team1: UILabel!
    @IBOutlet weak var result1: UILabel!
    @IBOutlet weak var team2: UILabel!
    @IBOutlet weak var result2: UILabel!
    @IBOutlet weak var predictButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        predictButton.layer.borderColor = UIColor.greenColor().CGColor
    }
    
    func updateUI() {
        //reset any existing activity information
        team1?.text = nil
        result1?.text = nil
        team2?.text = nil
        result2?.text = nil
        
        //load new information from our activity
        if let match = self.match {
            team1.text = match.team1
            result1.text = "\(match.result1)"
            team2.text = match.team2
            result2.text = "\(match.result2)"
        }
    }

}
