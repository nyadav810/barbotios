//
//  CategoryList.swift
//  BarBot iOS
//
//  Created by Naveen Yadav on 10/12/17.
//  Copyright © 2017 BarBot Inc. All rights reserved.
//

import Gloss

struct CategoryList: Gloss.Decodable {
    let categories: [Category]?
    
    // MARK: - Deserialization
    
    init?(json: JSON) {
        self.categories = "categories" <~~ json
    }
}
