//
//  Recipe.swift
//  barbot
//
//  Created by Naveen Yadav on 4/9/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Gloss

struct Recipe: Glossy {
    
    var name: String
    var id: String
    //var size: String?
    //var shot: String?
    var steps: [Step]
    var imageURLString: String
    var custom: Bool
    
    init(name: String, custom: Bool) {
        self.name = name
        self.id = ""
        self.steps = []
        self.imageURLString = "http://192.168.1.41/barbot/public/img/recipe_images/custom.png"
        self.custom = custom
    }
    
    init?(json: JSON) {
        guard let recipe: [String: AnyObject] = "recipe" <~~ json
            else { return nil }
        
        guard let steps: [Step] = "steps" <~~ recipe,
            let name: String = "name" <~~ recipe,
            let id: String = "id" <~~ recipe,
            let imageURLString: String = "img" <~~ recipe
            else { return nil }
        
        self.name = name
        self.id = id
        //self.size = "size" <~~ recipe
        //self.shot = "shot" <~~ recipe
        self.steps = steps
        self.imageURLString = imageURLString
        self.custom = false
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "recipe.name" ~~> self.name,
            "recipe.steps" ~~> self.steps,
            "recipe.img" ~~> self.imageURLString
        ])
    }
    
    func getRecipeVolume() -> Double {
        var volume: Double = 0.0
        for step in self.steps {
            if step.type == 1 {
                volume += step.quantity!
            }
        }
        return volume
    }
    
    func hasIce() -> Bool {
        if self.steps.isEmpty {
            return false
        }
        return self.steps.first!.type == 4
    }
    
    mutating func addIce(stepNumber: Int) {
        if !self.hasIce() {
            self.steps.insert(Step.init(step_number: stepNumber, type: 4, measurement: "oz"), atIndex: stepNumber)
        }
    }
    
    mutating func removeIce() {
        if self.hasIce() {
            self.steps.removeFirst()
        }
    }
}