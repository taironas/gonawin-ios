//
//  String+Utils.swift
//  Gonawin
//
//  Created by Remy JOURDE on 24/03/2016.
//  Copyright © 2016 Taironas. All rights reserved.
//

extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}
