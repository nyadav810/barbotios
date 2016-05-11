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
    
    init(step_number: Int, type: String, measurement: String) {
        self.step_number = step_number
        self.type = type
        self.measurement = measurement
    }
    
    init?(json: JSON) {
        guard let step_number: Int = "step_number" <~~ json,
            let type: String = "type" <~~ json
            else { return nil }
        
        self.step_number = step_number
        self.type = type
        
        self.ingredientId = "ingredientId" <~~ json
        self.quantity = "quantity" <~~ json
        self.measurement = "measurement" <~~ json
    }
}