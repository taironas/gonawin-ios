//
//  DefaultsKey.swift
//  Gonawin
//
//  Created by Remy JOURDE on 04/03/2016.
//  Copyright © 2016 Taironas. All rights reserved.
//

import SwiftyUserDefaults

extension DefaultsKeys {
    static let authorization = DefaultsKey<String>("authorization")
    static let currentUser = DefaultsKey<[String: AnyObject]?>("current_user")
}
