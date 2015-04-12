//
//  ActivityTableViewCell.swift
//  Gonawin
//
//  Created by Remy JOURDE on 06/04/2015.
//  Copyright (c) 2015 Taironas. All rights reserved.
//

import UIKit
import DateTools

class ActivityTableViewCell: UITableViewCell {

    var activity: Activity? {
        didSet {
            updateUI()
        }
    }
    @IBOutlet weak var activityIconView: UIView!
    @IBOutlet weak var activityContent: UILabel!
    @IBOutlet weak var activityTime: UILabel!
    
    let dateFormatter = NSDateFormatter()
    
    func updateUI() {
        //reset any existing activity information
        activityContent?.text = nil
        activityTime?.text = nil
        
        //load new information from our activity
        if let activity = self.activity {
            activityIconView.backgroundColor = activityIconViewBackgroundColor(activity)
            activityContent?.attributedText = builActivityContent(activity)
            activityTime?.text = publishedFromNow(activity.published)
        }
    }
    
    private func builActivityContent(activity: Activity) -> NSAttributedString {
        switch activity.type {
        case "predict":
            return predictActivityString(activity)
        case "match":
            return matchActivityString(activity)
        default:
            return activityString(activity)
        }
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
        switch activity.type {
        case "welcome":
            return UIColor(red: 52.0/255.0, green: 79.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        case "team":
            return UIColor(red: 52.0/255.0, green: 79.0/255.0, blue:219.0/255.0, alpha: 1.0)
        case "tournament":
            return UIColor(red: 46.0/255.0, green: 204.0/255.0, blue:113.0/255.0, alpha: 1.0)
        case "match":
            return UIColor(red: 241.0/255.0, green: 196.0/255.0, blue: 15.0/255.0, alpha: 1.0)
        case "accuracy":
            return UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        case "predict":
            return UIColor(red: 243.0/255.0, green: 156.0/255.0, blue: 18.0/255.0, alpha: 1.0)
        case "score":
            return UIColor(red: 155.0/255.0, green: 89.0/255.0, blue: 182.0/255.0, alpha: 1.0)
        default:
            return UIColor(red: 52.0/255.0, green: 79.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        }
    }
    
    private func publishedFromNow(published: String) -> String {
        dateFormatter.dateFormat = "YYYY-MM-ddEEEEEHH:mm:ss.AZ"
        
        let publishedDate = dateFormatter.dateFromString(published)
        let publishedInterval = publishedDate?.timeIntervalSinceNow
        
        return NSDate(timeIntervalSinceNow: publishedInterval!).timeAgoSinceNow()
    }
}
