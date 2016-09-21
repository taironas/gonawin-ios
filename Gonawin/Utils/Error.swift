//
//  Error.swift
//  Gonawin
//
//  Created by Remy JOURDE on 03/04/2015.
//  Copyright (c) 2015 Taironas. All rights reserved.
//

import UIKit
import RxSwift

func showError(_ error: Error, from viewController: UIViewController) {
    showErrorAlert(error, from: viewController)
}

func showErrorAlert(_ error: Error, from viewController: UIViewController) {
    let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    viewController.present(alert, animated: true, completion: nil)
}
