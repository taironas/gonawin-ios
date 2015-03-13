//
//  JSONDecodable.swift
//  Gonawin
//
//  Created by Remy JOURDE on 13/09/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import Foundation

protocol JSONDecodable {
    static func decode(json: JSON) -> Self?
}
