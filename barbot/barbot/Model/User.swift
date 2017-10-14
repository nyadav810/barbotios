//
//  User.swift
//  BarBot iOS
//
//  Created by Naveen Yadav on 10/12/17.
//  Copyright © 2017 BarBot Inc. All rights reserved.
//

import Gloss

struct User: Gloss.Decodable {
    let userId: String
    let name: String?
    let email: String?
    let password: String?
    
    init(userId: String, name: String, email: String, password: String) {
        self.userId = userId
        self.name = name
        self.email = email
        self.password = password
    }
    
    // MARK: - Deserialization
    
    init?(json: JSON) {
        guard let userId: String = "user_id" <~~ json else {
            return nil
        }
        
        self.userId = userId
        self.name = "name" <~~ json
        self.email = "email" <~~ json
        self.password = "password" <~~ json
    }
}
