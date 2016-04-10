//
//  Menu.swift
//  barbot
//
//  Created by Naveen Yadav on 4/9/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Foundation
import Gloss

public struct Menu: Decodable {
    
    public let menu: [Recipe]?
    
    public init?(json: JSON) {
        self.menu = "menu" <~~ json
    }
}