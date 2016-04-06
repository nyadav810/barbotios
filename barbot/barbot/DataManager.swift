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

    func getDrinkMenuDataFromServer() {
        let url : NSURL = NSURL(string: ServerURL)!
        let data : NSData = NSData(contentsOfURL: url)!
        
        parseDrinkMenuJSON(data)
    }
    
    // Get drinks from local file for DrinkTableViewController's table view
    func getDrinkMenuDataFromFile() {
        let data = self.getJSONDataFromFile("drinks")
        self.parseDrinkMenuJSON(data)
    }
    
    // User selects a drink, get Recipe from local file to display in
    // DrinkViewController
    func getRecipeDataFromFile(drinkId: Int) {
        var json: Payload!
        let data: NSData! = self.getJSONDataFromFile("recipe")
        
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? Payload
        } catch {
            print("error serializing JSON: \(error)")
        }
    }
    
    // Retrieve JSON from local file, convert to NSData and return
    private func getJSONDataFromFile(jsonFileName: String) -> NSData {
        let filePath = NSBundle.mainBundle().pathForResource(jsonFileName, ofType:"json")
        let data = try! NSData(contentsOfFile:filePath!,
                               options: NSDataReadingOptions.DataReadingUncached)
        return data
    }
    
    private func parseDrinkMenuJSON(data: NSData) {
        var json: Payload!
        
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? Payload
            if let drinks = json["drinks"] as? [[String: AnyObject]] {
                for drink in drinks {
                    guard let d = drink["drink"] as? [String : AnyObject],
                        let name = d["name"] as? String,
                        let id = d["id"] as? String else {
                            return
                    }
                    
                    let drinkObject : Drink = Drink.init(name: name, id: id, managedObjectContext: self.managedObjectContext)
                    print(drinkObject.name)
                }
            }
        } catch {
            print("error serializing JSON: \(error)")
        }
    }
}