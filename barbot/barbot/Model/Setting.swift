//
//  Setting.swift
//  barbot
//
//  Created by Naveen Yadav on 10/14/17.
//  Copyright © 2017 BarBot. All rights reserved.
//

import Foundation

class Setting {
    let title: String
    
    init(title: String) {
        self.title = title
    }
    
    class func allSettings() -> Array<Setting> {
        return [ Setting(title:"Home"), Setting(title:"Settings") ]
    }
}
