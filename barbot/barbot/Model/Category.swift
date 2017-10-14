//
//  Category.swift
//  BarBot iOS
//
//  Created by Naveen Yadav on 10/12/17.
//  Copyright © 2017 BarBot Inc. All rights reserved.
//

import Gloss

struct Category: Glossy {
    let categoryId: String
    let name: String?
    let recipes: [Recipe]?
    let subCategories: [Category]?
    
    // MARK: - Deserialization
    
    init?(json: JSON) {
        guard let category: [String: AnyObject] = "category" <~~ json else {
            return nil
        }
        
        guard let categoryId: String = "category_id" <~~ category else {
            return nil
        }
        
        self.categoryId = categoryId
        self.name = "name" <~~ category
        self.recipes = "recipes" <~~ category
        self.subCategories = "sub_categories" <~~ category
    }
    
    // MARK: - Serialization
    
    func toJSON() -> JSON? {
        return jsonify([
            "category_id" ~~> self.categoryId
        ])
    }
}
