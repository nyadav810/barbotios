//
//  Menu.swift
//  barbot
//
//  Created by Naveen Yadav on 4/9/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Gloss

struct Menu: Decodable {
    
    let menu: [Drink]?
    
    init?(json: JSON) {
        self.menu = "menu" <~~ json
    }
}