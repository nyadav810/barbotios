//
//  PourViewController.swift
//  barbot
//
//  Created by Naveen Yadav on 4/3/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Foundation
import UIKit

class PourViewController : UIViewController {

    @IBOutlet weak var thanksLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func configureView() {
        thanksLabel.hidden = true
    }
    
    @IBAction func pourDrink(sender: AnyObject) {
        // Send signal to barbot to pour drink
        thanksLabel.hidden = false
    }
}
