//
//  UserInfo.swift
//  Gonawin
//
//  Created by Remy JOURDE on 28/03/2015.
//  Copyright (c) 2015 Taironas. All rights reserved.
//

struct UserInfo {
    let accessToken: String
    let id: Int
    let email: String
    let name: String
}

typealias UserInfoCompletionHandler = (_ userInfo: UserInfo?, _ error: NSError?) -> Void
