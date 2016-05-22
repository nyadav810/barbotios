//
//  Event.swift
//  BarBot
//
//  Created by Naveen Yadav on 5/21/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Gloss

struct Event: Decodable {
    
    let event: String?
    let data: String?
    
    init?(json: JSON) {
        self.event = "event" <~~ json
        self.data = "data" <~~ json
    }
}