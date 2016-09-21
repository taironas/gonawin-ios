//
//  PredictButton.swift
//  Gonawin
//
//  Created by Remy JOURDE on 24/03/2016.
//  Copyright © 2016 Taironas. All rights reserved.
//

import UIKit

class PredictButton: UIButton {
    
    @IBInspectable var normalBackgroundColor : UIColor = UIColor.greenSeaFoam {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var normalBorderColor : UIColor = UIColor.greenSeaFoam {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var highlightedBackgroundColor : UIColor = UIColor.seaFoam {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var highlightedBorderColor : UIColor = UIColor.seaFoam {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var disabledBorderColor : UIColor = UIColor.groupTableViewBackground {
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
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                layer.borderColor = highlightedBorderColor.cgColor
            } else {
                self.backgroundColor = normalBackgroundColor
                layer.borderColor = normalBorderColor.cgColor
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.backgroundColor = normalBackgroundColor
                layer.borderColor = normalBorderColor.cgColor
            } else {
                self.backgroundColor = UIColor.clear
                layer.borderColor = disabledBorderColor.cgColor
            }
        }
    }
}
