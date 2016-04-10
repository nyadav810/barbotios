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
    private func getJSONDataFromFile(jsonFileName: String) -> Payload {
        let filePath = NSBundle.mainBundle().pathForResource(jsonFileName, ofType:"json")
        let data = try! NSData(contentsOfFile:filePath!,
                               options: NSDataReadingOptions.DataReadingUncached)
        var json: Payload!
        
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? Payload
        } catch {
            print("error serializing JSON: \(error)")
        }
        
        return json
    }
    
    // MARK: menu.json get methods

    // Get recipes from server using Websocket
    func getMenuDataFromServer() {
        //let data : NSData = socket.blah
        
        //parseDrinkMenuJSON(data)
    }
    
    // Get recipes from local file for DrinkTableViewController's table view
    func getMenuDataFromFile() {
        let json: Payload! = self.getJSONDataFromFile("menu")
        self.parseMenuJSON(json)
    }
    
    // Parse menu JSON using Gloss
    private func parseMenuJSON(json: Payload) {
        guard let menu = Menu(json: json) else {
            print("Error initializing object")
            return
        }
        
        for recipe: Recipe in menu.menu! {
            let drink: Drink = Drink.init(name: recipe.name, recipe_id: recipe.recipe_id, managedObjectContext: self.managedObjectContext)
            print("\(drink.recipe_id): \(drink.name)")
        }
    }
    
    // MARK: recipe.json get methods
    
    // Get Ingredients from local file to display in
    // DrinkViewController
    func getRecipeDataFromFile() {
        let json: Payload = self.getJSONDataFromFile("recipe")
        self.parseRecipeJSON(json)
    }
    
    private func parseRecipeJSON(json: Payload) {
        
    }
    
    // MARK: ingredients.json get methods
    
    func getIngredientDataFromFileForBarbot() {
        
    }
    
}