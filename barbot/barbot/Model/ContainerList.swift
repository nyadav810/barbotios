//
//  ContainerList.swift
//  BarBot iOS
//
//  Created by Naveen Yadav on 10/13/17.
//  Copyright © 2017 BarBot Inc. All rights reserved.
//

import Gloss

struct ContainerList: Glossy {
    let containers: [Container]?
    let barbotId: String?
    
    // MARK: - Deserialization
    
    init?(json: JSON) {
        self.containers = "containers" <~~ json
        self.barbotId = "barbot_id" <~~ json
    }
    
    // MARK: - Serialization
    func toJSON() -> JSON? {
        return jsonify([
            "containers" ~~> self.containers,
            "barbot_id" ~~> self.barbotId
        ])
    }
}

