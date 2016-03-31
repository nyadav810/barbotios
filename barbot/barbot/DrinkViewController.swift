//
//  DrinkViewController.swift
//  barbot
//
//  Created by Naveen Yadav on 3/26/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Foundation
import UIKit

class DrinkViewController : UIViewController {
    
    @IBOutlet weak var titleLabel: UINavigationItem!
    var drink : Drink
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func configureView() {
        self.titleLabel.title = self.drink.name
    }
}