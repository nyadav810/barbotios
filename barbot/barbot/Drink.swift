//
//  Drink.swift
//  barbot
//
//  Created by Naveen Yadav on 4/26/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Gloss

struct Drink: Decodable {
    
    let recipeId: String?
    let name: String?
    
    init?(json: JSON) {
        self.recipeId = "id" <~~ json
        self.name = "name" <~~ json
    }
}
