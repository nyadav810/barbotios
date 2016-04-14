//
//  DataManager.swift
//  barbot
//
//  Created by Naveen Yadav on 3/23/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

// TODO: Uncomment websocket init and getFromServer methods when we have a server URL

import Foundation
import UIKit
import Starscream

class DataManager: WebSocketDelegate {

//    var socket: WebSocket!
    typealias Payload = [String: AnyObject]
    
    // Initialize DataManager with AppDelegate properties
    init() {
        // initialize web socket
//        self.socket = WebSocket(url: NSURL(string: "http://")!)
//        socket.delegate = self
//        socket.connect()
    }
    
    // Serialize JSON from NSData
    private func getJSONFromData(data: NSData) -> Payload {
        var json: Payload!
        
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? Payload
        } catch {
            print("error serializing JSON: \(error)")
        }
        
        return json
    }
    
    // Retrieve JSON from server, convert to Payload and return
    private func getJSONDataFromServer(jsonTextPayload: String) -> Payload {
        let data: NSData! = jsonTextPayload.dataUsingEncoding(NSUTF8StringEncoding)
        return getJSONFromData(data)
    }
    
    // Retrieve JSON from local file, convert to Payload and return
    private func getJSONDataFromFile(jsonFileName: String) -> Payload {
        let filePath = NSBundle.mainBundle().pathForResource(jsonFileName, ofType:"json")
        let data = try! NSData(contentsOfFile:filePath!,
                               options: NSDataReadingOptions.DataReadingUncached)
        return getJSONFromData(data)
    }
    
    // MARK: - menu.json get methods

    // Get recipes from server using Websocket
//    func getMenuDataFromServer(barbotId: String) -> [Recipe]? {
//        socket.writeString("getMenu(" + barbotId + ")")
//        
//        var menu: [Recipe]?
//        socket.onText = {(text: String) in
//            let json: Payload! = self.getJSONDataFromServer(text)
//            menu = self.parseMenuJSON(json)
//        }
//        
//        return menu
//    }
    
    // Get recipes from local file for DrinkTableViewController's table view
    func getMenuDataFromFile(file: String) -> [Recipe]? {
        let json: Payload! = self.getJSONDataFromFile(file)
        return self.parseMenuJSON(json)
    }
    
    // Parse menu JSON using Gloss
    private func parseMenuJSON(json: Payload) -> [Recipe]? {
        guard let menu = Menu(json: json) else {
            print("Error initializing object")
            return nil
        }
        
        return menu.menu!
    }
    
    // MARK: - recipe.json get methods
    
//    func getRecipeDataFromServer(recipeId: String) -> Recipe? {
//        socket.writeString("getRecipe(" + recipeId + ")")
//        
//        var recipe: Recipe?
//        socket.onText = {(text: String) in
//            let json: Payload! = self.getJSONDataFromServer(text)
//            recipe = self.parseRecipeJSON(json)
//        }
//        
//        return recipe
//    }
    
    // Get Ingredients from local file to display in
    // DrinkViewController
    func getRecipeDataFromFile(file: String) -> Recipe? {
        let json: Payload = self.getJSONDataFromFile(file)
        return self.parseRecipeJSON(json)
    }
    
    private func parseRecipeJSON(json: Payload) -> Recipe? {
        guard let recipe = Recipe(json: json) else {
            print("Error initializing object")
            return nil
        }
        
        return recipe
    }
    
    // MARK: - ingredients.json get methods
    
//    func getIngredientDataFromServer(barbotId: String) -> [Ingredient]? {
//        socket.writeString("getIngredients(" + barbotId + ")")
//        
//        var ingredientList: IngredientList?
//        socket.onText = {(text: String) in
//            let json: Payload! = self.getJSONDataFromServer(text)
//            ingredientList = self.parseIngredientJSON(json)
//        }
//        
//        return ingredientList
//    }
    
    func getIngredientDataFromFile(file: String) -> IngredientList? {
        let json: Payload = self.getJSONDataFromFile(file)
        return self.parseIngredientJSON(json)
    }
    
    private func parseIngredientJSON(json: Payload) -> IngredientList? {
        guard let ingredients = IngredientList(json: json) else {
            print("Error initializing object")
            return nil
        }
        return ingredients
    }
    
    // MARK: Websocket Delegate Methods.
    
    func websocketDidConnect(ws: WebSocket) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(ws: WebSocket, error: NSError?) {
        if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
    }
    
    func websocketDidReceiveMessage(ws: WebSocket, text: String) {
        print("Received text: \(text)")
    }
    
    func websocketDidReceiveData(ws: WebSocket, data: NSData) {
        print("Received data: \(data.length)")
    }
}