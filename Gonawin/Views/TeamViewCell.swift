//
//  TeamViewCell.swift
//  Gonawin
//
//  Created by Remy JOURDE on 15/03/2016.
//  Copyright © 2016 Taironas. All rights reserved.
//

import UIKit
import GonawinEngine

class TeamViewCell: UICollectionViewCell {
    
    var team: Team? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var avatarImageView: UIWebView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lighterGray.cgColor
        layer.cornerRadius = 3.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lighterGray.cgColor
        layer.cornerRadius = 3.0
    }
    
    func updateUI() {
        //reset any existing activity information
        nameLabel?.text = nil
        
        //load new information from our user
        if let team = self.team {
            let url = URL(string: (team.imageURL + "&size=50").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            avatarImageView.loadRequest(URLRequest(url: url))
            
            nameLabel.text = team.name
        }
    }
}
