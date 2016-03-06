//
//  ActivityTableViewCell.swift
//  Gonawin
//
//  Created by Remy JOURDE on 06/04/2015.
//  Copyright (c) 2015 Taironas. All rights reserved.
//

import UIKit
import GonawinEngine
import DateTools
import FontAwesomeKit

class ActivityTableViewCell: UITableViewCell {

    var activity: Activity? {
        didSet {
            updateUI()
        }
    }
    @IBOutlet weak var activityIconView: UIImageView!
    @IBOutlet weak var activityContent: UILabel!
    @IBOutlet weak var activityTime: UILabel!
    
    let dateFormatter = NSDateFormatter()
    
    override func layoutSubviews() {
        let imageLayer = activityIconView.layer
        imageLayer.cornerRadius = activityIconView.frame.size.height/2
        imageLayer.masksToBounds = true
    }
    
    func updateUI() {
        //reset any existing activity information
        activityContent?.text = nil
        activityTime?.text = nil
        
        //load new information from our activity
        if let activity = self.activity {
            activityIconView.backgroundColor = activityIconViewBackgroundColor(activity)
            activityIconView.image = activityIconViewImage(activity)
            activityContent?.attributedText = builActivityContent(activity)
            activityTime?.text = publishedFromNow(activity.published)
        }
    }
    
    private enum ActivityType: String {
        case Welcome = "welcome"
        case Team = "team"
        case Tournament = "tournament"
        case Match = "match"
        case Accuracy = "accuracy"
        case Predict = "predict"
        case Score = "score"
        case Invitation = "invitation"
    }
    
    private func builActivityContent(activity: Activity) -> NSAttributedString {
        if let activityType = ActivityType(rawValue: activity.type) {
            switch activityType {
            case .Predict:
                return predictActivityString(activity)
            case .Match:
                return matchActivityString(activity)
            default:
                return activityString(activity)
            }
        }
        return activityString(activity)
    }
    
    private func predictActivityString(activity: Activity) -> NSMutableAttributedString {
        let target = activity.target?.displayName
        let actor = activity.actor?.displayName
        let object = activity.object?.displayName
        let activityString = target! + ": " + actor! + " \(activity.verb) " + object! as NSString
        
        let attributedString = NSMutableAttributedString(string: activityString as String)
        
        let attributes = [NSForegroundColorAttributeName: UIColor.blueColor(), NSFontAttributeName: UIFont.boldSystemFontOfSize(activityContent!.font.pointSize)]
        
        attributedString.addAttributes(attributes, range: activityString.rangeOfString(target!))
        attributedString.addAttributes(attributes, range: activityString.rangeOfString(actor!))
        attributedString.addAttributes(attributes, range: activityString.rangeOfString(object!))
        
        return attributedString
    }
    
    private func matchActivityString(activity: Activity) -> NSMutableAttributedString {
        let actor = activity.actor?.displayName
        let object = activity.object?.displayName
        let target = activity.target?.displayName
        let activityString = actor! + ": " + object! + " \(activity.verb) " + target! as NSString
        
        let attributedString = NSMutableAttributedString(string: activityString as String)
        
        let attributes = [NSForegroundColorAttributeName: UIColor.blueColor(), NSFontAttributeName: UIFont.boldSystemFontOfSize(activityContent!.font.pointSize)]
        
        attributedString.addAttributes(attributes, range: activityString.rangeOfString(actor!))
        attributedString.addAttributes(attributes, range: activityString.rangeOfString(object!))
        attributedString.addAttributes(attributes, range: activityString.rangeOfString(target!))
        
        return attributedString
    }
    
    private func activityString(activity: Activity) -> NSMutableAttributedString {
        let actor = activity.actor?.displayName
        let object = activity.object?.displayName
        let activityString = actor! + " \(activity.verb) " + object! as NSString
        
        let attributedString = NSMutableAttributedString(string: activityString as String)
        
        let attributes = [NSForegroundColorAttributeName: UIColor.blueColor(), NSFontAttributeName: UIFont.boldSystemFontOfSize(activityContent!.font.pointSize)]
        
        attributedString.addAttributes(attributes, range: activityString.rangeOfString(actor!))
        attributedString.addAttributes(attributes, range: activityString.rangeOfString(object!))
        
        return attributedString
    }
    
    private func activityIconViewBackgroundColor(activity: Activity) -> UIColor {
        if let activityType = ActivityType(rawValue: activity.type) {
            switch activityType {
            case .Welcome:
                return UIColor(red: 52.0/255.0, green: 79.0/255.0, blue: 219.0/255.0, alpha: 1.0)
            case .Team:
                return UIColor(red: 52.0/255.0, green: 79.0/255.0, blue:219.0/255.0, alpha: 1.0)
            case .Tournament:
                return UIColor(red: 46.0/255.0, green: 204.0/255.0, blue:113.0/255.0, alpha: 1.0)
            case .Match:
                return UIColor(red: 241.0/255.0, green: 196.0/255.0, blue: 15.0/255.0, alpha: 1.0)
            case .Accuracy:
                return UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
            case .Predict:
                return UIColor(red: 243.0/255.0, green: 156.0/255.0, blue: 18.0/255.0, alpha: 1.0)
            case .Score:
                return UIColor(red: 155.0/255.0, green: 89.0/255.0, blue: 182.0/255.0, alpha: 1.0)
            default:
                return UIColor(red: 52.0/255.0, green: 79.0/255.0, blue: 219.0/255.0, alpha: 1.0)
            }
        }
        
        return UIColor(red: 52.0/255.0, green: 79.0/255.0, blue: 219.0/255.0, alpha: 1.0)
    }
    
    private func activityIconViewImage(activity: Activity) -> UIImage {
        var icon: FAKFontAwesome
        if let activityType = ActivityType(rawValue: activity.type) {
            switch activityType {
            case .Welcome:
                icon = FAKFontAwesome.checkIconWithSize(20)
            case .Team:
                icon = FAKFontAwesome.usersIconWithSize(20)
            case .Tournament:
                icon = FAKFontAwesome.trophyIconWithSize(20)
            case .Match:
                icon = FAKFontAwesome.compressIconWithSize(20)
            case .Accuracy:
                icon = FAKFontAwesome.barChartIconWithSize(20)
            case .Predict:
                icon = FAKFontAwesome.crosshairsIconWithSize(20)
            case .Score:
                icon = FAKFontAwesome.listIconWithSize(20)
            case .Invitation:
                icon = FAKFontAwesome.bullhornIconWithSize(20)
            }
        }
        else {
            // default icon
            icon = FAKFontAwesome.checkIconWithSize(25)
        }
        
        icon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        return icon.imageWithSize(CGSizeMake(35,35))
    }
    
    private func publishedFromNow(published: String) -> String {
        dateFormatter.dateFormat = "YYYY-MM-ddEEEEEHH:mm:ss.AZ"
        
        let publishedDate = dateFormatter.dateFromString(published)
        let publishedInterval = publishedDate?.timeIntervalSinceNow
        
        return NSDate(timeIntervalSinceNow: publishedInterval!).timeAgoSinceNow()
    }
}
