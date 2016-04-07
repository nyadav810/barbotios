//
//  Ingredient.swift
//  barbot
//
//  Created by Naveen Yadav on 4/7/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Foundation

class Ingredient {
    
    enum Type : String {
        case Alcohol = "alcohol"
        case Liqueur = "liqueur"
        case Syrup = "syrup"
        case Mixer = "mixer"
        case Other = "other"
    }
    
    var name : String
    var brand : String
    var type : Type
    var ingredient_id : String
    
    init(name: String, brand: String, type: String, ingredient_id: String) {
        self.name = name
        self.brand = name
        switch type {
            case "alcohol":
                self.type = .Alcohol
            case "liqueur":
                self.type = .Liqueur
            case "syrup":
                self.type = .Syrup
            case "mixer":
                self.type = .Mixer
            default:
                self.type = .Other
        }
        self.ingredient_id = ingredient_id
    }
    
}