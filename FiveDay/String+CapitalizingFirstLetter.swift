//
//  String+CapitalizingFirstLetter.swift
//  FiveDay
//
//  Created by Eddie Caballero on 8/7/18.
//  Copyright © 2018 Eddie Caballero. All rights reserved.
//

import Foundation

extension String
{
    func capitalizingFirstLetter() -> String
    {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
