//
//  RecipeViewController.swift
//  barbot
//
//  Created by Naveen Yadav on 3/26/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Foundation
import UIKit

class RecipeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UINavigationItem!
    @IBOutlet weak var imageView: UIImageView!
    var recipe: Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    }
    
    func configureView() {
        self.titleLabel.title = self.recipe.name
    }
    
    @IBAction func orderDrink(sender: AnyObject) {
        // Send order to barbot web server
    }
}