//
//  Step.swift
//  barbot
//
//  Created by Naveen Yadav on 4/10/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Gloss

struct Step: Decodable {
    var step_number: Int
    var type: String
    var ingredientId: String?
    var quantity: Double?
    var measurement: String?
    
    init(step_number: Int, type: String) {
        self.step_number = step_number
        self.type = type
    }
    
    init?(json: JSON) {
        guard let step_number: Int = "step_number" <~~ json,
            type: String = "type" <~~ json
            else { return nil }
        
        self.step_number = step_number
        switch type {
            case "add_ingredient":
                self.type = "Add"
            case "mix":
                self.type = "Mix"
            case "pour":
                self.type = "Pour"
            case "add_ice":
                self.type = "Add Ice"
            default:
                return nil;
        }
        
        self.ingredientId = "ingredientId" <~~ json
        self.quantity = "quantity" <~~ json
        self.measurement = "measurement" <~~ json
    }
}