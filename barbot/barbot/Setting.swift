//
//  Setting.swift
//  barbot
//
//  Created by Naveen Yadav on 4/16/16.
//  Copyright © 2016 BarBot. All rights reserved.
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