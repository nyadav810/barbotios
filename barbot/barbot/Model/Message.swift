//
//  Message.swift
//  BarBot iOS
//
//  Created by Naveen Yadav on 10/13/17.
//  Copyright © 2017 BarBot Inc. All rights reserved.
//

import Gloss

struct Message: Glossy {
    let type: String
    let command: String
    let data: JSON
    let result: String?
    
    init(type: String, command: String, data: JSON, result: String) {
        self.type = type
        self.command = command
        self.data = data
        self.result = result
    }
    
    // MARK: - Deserialization
    
    init?(json: JSON) {
        guard let type: String = "type" <~~ json,
            let command: String = "command" <~~ json,
            let data: JSON = "data" <~~ json else {
                return nil
        }
        
        self.type = type
        self.command = command
        self.data = data
        self.result = "result" <~~ json
    }
    
    // MARK: - Serialization
    
    func toJSON() -> JSON? {
        return jsonify([
            "type" ~~> self.type,
            "command" ~~> self.command,
            "data" ~~> self.data,
            "result" ~~> self.result
        ])
    }
}
