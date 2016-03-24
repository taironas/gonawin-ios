//
//  PredictButton.swift
//  Gonawin
//
//  Created by Remy JOURDE on 24/03/2016.
//  Copyright © 2016 Taironas. All rights reserved.
//

import UIKit

class PredictButton: UIButton {
    
    @IBInspectable var normalBackgroundColor : UIColor = UIColor.greenSeaFoamColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var normalBorderColor : UIColor = UIColor.greenSeaFoamColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var highlightedBackgroundColor : UIColor = UIColor.seaFoamColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var highlightedBorderColor : UIColor = UIColor.seaFoamColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var disabledBorderColor : UIColor = UIColor.groupTableViewBackgroundColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat = 6.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    override var highlighted: Bool {
        didSet {
            if highlighted {
                layer.borderColor = highlightedBorderColor.CGColor
            } else {
                self.backgroundColor = normalBackgroundColor
                layer.borderColor = normalBorderColor.CGColor
            }
        }
    }
    
    override var enabled: Bool {
        didSet {
            if enabled {
                self.backgroundColor = normalBackgroundColor
                layer.borderColor = normalBorderColor.CGColor
            } else {
                self.backgroundColor = UIColor.clearColor()
                layer.borderColor = disabledBorderColor.CGColor
            }
        }
    }
}
