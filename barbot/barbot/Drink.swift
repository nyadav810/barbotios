//
//  Drink.swift
//  barbot
//
//  Created by Naveen Yadav on 4/26/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Gloss

struct Drink: Decodable {
    
    let drinkId: String?
    let recipeId: String?
    let name: String?
    
    init(name: String) {
        self.drinkId = "custom_drink"
        self.recipeId = "custom_recipe"
        self.name = name
    }
    
    init?(json: JSON) {
        self.drinkId = "id" <~~ json
        self.recipeId = "recipeId" <~~ json
        self.name = "name" <~~ json
    }
}

func == (left: Drink, right: Drink) -> Bool {
    return (left.drinkId == right.drinkId) && (left.recipeId == right.recipeId) && (left.name == right.name)
}

func != (left: Drink, right: Drink) -> Bool {
    return !(left == right)
}
