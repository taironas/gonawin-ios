//
//  Errors.swift
//  GonawinEngine
//
//  Created by Remy JOURDE on 27/02/2016.
//  Copyright © 2016 Remy Jourde. All rights reserved.
//

enum GonawinError: String {
    case CouldNotParseJSON
}

extension GonawinError: ErrorType { }