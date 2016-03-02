//
//  JSONAble.swift
//  GonawinEngine
//
//  Created by Remy JOURDE on 27/02/2016.
//  Copyright © 2016 Remy Jourde. All rights reserved.
//

protocol JSONAble {
    static func fromJSON(_: JSONDictionary) -> Self
}
