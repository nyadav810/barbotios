//
//  Step.swift
//  barbot
//
//  Created by Naveen Yadav on 4/10/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Foundation
import Gloss

struct Step: Decodable {
    let step_number: Int
    let type: String
    let ingredient_id: String?
    let quantity: Double?
    let measurement: String?
    
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
        
        self.ingredient_id = "ingredient_id" <~~ json
        self.quantity = "quantity" <~~ json
        self.measurement = "measurement" <~~ json
    }
}