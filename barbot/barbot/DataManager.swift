//
//  DataManager.swift
//  barbot
//
//  Created by Naveen Yadav on 3/23/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataManager {
    
    var managedObjectContext : NSManagedObjectContext!
    let ServerURL = "/drinks.json"
    typealias Payload = [String: AnyObject]
    
    init() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
    }

    func getDrinkMenuDataFromServerWithSuccess(success: ((drinkMenuData: NSData!) -> Void)) {
        
        let url : NSURL = NSURL(string: ServerURL)!
        let rawData : NSData = NSData(contentsOfURL: url)!
        
        var json: Payload!
        do {
            json = try NSJSONSerialization.JSONObjectWithData(rawData, options: NSJSONReadingOptions()) as? Payload
            if let drinks = json["drinks"] as? [[String: AnyObject]] {
                for drink in drinks {
                    if let d = drink["drink"] as? [String : AnyObject] {
                        if let name = d["name"] as? String {
                            let drinkObject : Drink = Drink.init(name: name, managedObjectContext: self.managedObjectContext)
                            print(drinkObject.name)
                        }
                    }
                }
            }
        } catch {
            print("error serializing JSON: \(error)")
        }
    }
    
    func getDrinkMenuDataFromFile() {
        var json: Payload!
        
        let filePath = NSBundle.mainBundle().pathForResource("drinks", ofType:"json")
        let data = try! NSData(contentsOfFile:filePath!,
                                options: NSDataReadingOptions.DataReadingUncached)
    
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? Payload
            if let drinks = json["drinks"] as? [[String: AnyObject]] {
                for drink in drinks {
                    if let d = drink["drink"] as? [String : AnyObject] {
                        if let name = d["name"] as? String {
                            let drinkObject : Drink = Drink.init(name: name, managedObjectContext: self.managedObjectContext)
                            print(drinkObject.name)
                        }
                    }
                }
            }
        } catch {
            print("error serializing JSON: \(error)")
        }
    }
}