//
//  TournamentViewCell.swift
//  Gonawin
//
//  Created by Remy Jourde on 21/09/2016.
//  Copyright © 2016 Taironas. All rights reserved.
//

import UIKit
import GonawinEngine

class TournamentViewCell: UICollectionViewCell {
    
    var tournament: Tournament? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var logoImageView: UIWebView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let dateFormatter = DateFormatter()
    
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
        
        guard let tournament = self.tournament else { return }
        
        let url = URL(string: (tournament.imageURL + "&size=50").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        logoImageView.loadRequest(URLRequest(url: url))
        
        nameLabel.text = tournament.name
        dateLabel.text = "\(formattedDate(from: tournament.start)) - \(formattedDate(from: tournament.end))"
    }
    
    fileprivate func formattedDate(from string: String) -> String {
        dateFormatter.dateFormat = "YYYY-MM-ddEEEEEHH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let truncatedDate = string.substring(to: string.index(before: string.endIndex))
        
        let date = dateFormatter.date(from: truncatedDate)
        
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date!)
    }
}
