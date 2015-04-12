//
//  Error.swift
//  Gonawin
//
//  Created by Remy JOURDE on 03/04/2015.
//  Copyright (c) 2015 Taironas. All rights reserved.
//

import UIKit

func showError(viewController: UIViewController, error: NSError) {
    showErrorDescription(viewController, error.localizedDescription)
}

func showErrorDescription(viewController: UIViewController, description: String) {
    let alert = UIAlertController(title: "Error", message: description, preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
    viewController.presentViewController(alert, animated: true, completion: nil)
}
