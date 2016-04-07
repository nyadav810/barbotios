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
import Starscream

class DataManager {
    
    var managedObjectContext : NSManagedObjectContext!
    var socket : WebSocket!
    typealias Payload = [String: AnyObject]
    
    // Initialize DataManager with AppDelegate properties
    init() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        self.socket = appDelegate.socket
    }
    
    // Retrieve JSON from local file, convert to NSData and return
    private func getJSONDataFromFile(jsonFileName: String) -> NSData {
        let filePath = NSBundle.mainBundle().pathForResource(jsonFileName, ofType:"json")
        let data = try! NSData(contentsOfFile:filePath!,
                               options: NSDataReadingOptions.DataReadingUncached)
        return data
    }
    
    // MARK: menu.json get methods

    // Get recipes from server using Websocket
    func getMenuDataFromServer() {
        //let data : NSData = NSData(contentsOfURL: url)!
        
        //parseDrinkMenuJSON(data)
    }
    
    // Get recipes from local file for DrinkTableViewController's table view
    func getMenuDataFromFile() {
        let data: NSData = self.getJSONDataFromFile("menu")
        self.parseMenuJSON(data)
    }
    
    private func parseMenuJSON(data: NSData) {
        var json: Payload!
        
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? Payload
            if let menu = json["menu"] as? [Payload] {
                for drink in menu {
                    guard let d = drink["drink"] as? Payload,
                        let name = d["name"] as? String,
                        let recipe_id = d["recipe_id"] as? String else {
                            return
                    }
                    
                    let drinkObject : Drink = Drink.init(name: name, recipe_id: recipe_id, managedObjectContext: self.managedObjectContext)
                    print(drinkObject.name)
                }
            }
        } catch {
            print("error serializing JSON: \(error)")
        }
    }
    
    // MARK: recipe.json get methods
    
    // Get Ingredients from local file to display in
    // DrinkViewController
    func getRecipeDataFromFile() {
        let data: NSData = self.getJSONDataFromFile("recipe")
        self.parseRecipeJSON(data)
    }
    
    private func parseRecipeJSON(data: NSData) {
        var json: Payload!
        
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? Payload
            //if let recipe = json["recipe"] as?
        } catch {
            print("error serializing JSON: \(error)")
        }
    }
    
}