//
//  MatchesViewController.swift
//  Gonawin
//
//  Created by Remy JOURDE on 23/03/2016.
//  Copyright © 2016 Taironas. All rights reserved.
//

import UIKit
import GonawinEngine

class MatchesViewController: UITableViewController {

    var calendar: TournamentCalendar? {
        didSet {
            tableView.reloadData()
        }
    }
    
    fileprivate let dateFormatter = DateFormatter()
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return calendar?.days.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendar?.days[section].matches.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return format(calendar?.days[section].day)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureCell(for: indexPath)
    }
    
    fileprivate func configureCell(for indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "MatchTableViewCell", bundle: nil ), forCellReuseIdentifier: TableViewCellIdentifier.Match.rawValue)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.Match.rawValue, for: indexPath) as! MatchTableViewCell
        cell.match = calendar?.days[indexPath.section].matches[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 109.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 5, width: tableView.frame.width, height: 20))
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = UIColor.lightGray
        titleLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        let headerView = UIView()
        headerView.addSubview(titleLabel)
        headerView.backgroundColor = UIColor.groupTableViewBackground
        
        return headerView;
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    fileprivate func format(_ day: String?) -> String {
        guard let day = day else {
            return ""
        }
        
        dateFormatter.dateFormat = "yyyy-MM-ddEEEEEHH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let date = dateFormatter.date(from: day)
        
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: date!)
    }
}
