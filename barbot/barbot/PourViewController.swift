//
//  PourViewController.swift
//  barbot
//
//  Created by Naveen Yadav on 4/3/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import UIKit

class PourViewController: UIViewController {
    
    var dataManager: DataManager!
    var result: String!
    
    @IBOutlet weak var pourButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.pourButton.enabled = self.dataManager.status
    }
    
    override func viewDidAppear(animated: Bool) {
        self.dataManager.socket.onText = { (text: String) in
            self.dataManager.parseResponseDataFromServer(text)
            self.pourButton.enabled = self.dataManager.status
        }
    }
    
    @IBAction func pourDrink(sender: AnyObject) {
        // Send signal to barbot to pour drink
        self.dataManager.requestDataFromServer("pour_drink", args: ["drink_order_id": self.dataManager.drinkOrder])
        
        self.showAlertController()
    }
    
    // Creates and shows a AlertView prompt that:
    // 1. Thanks the user
    // 2. Allows the user to tap to return to the menu
    func showAlertController() {
        let alert: UIAlertController = UIAlertController.init(title: "Thank you for ordering!", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        let returnButton: UIAlertAction = UIAlertAction.init(title: "Return to menu", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
                // return to menu
                self.navigationController?.popToRootViewControllerAnimated(true)
            })
        alert.addAction(returnButton)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
