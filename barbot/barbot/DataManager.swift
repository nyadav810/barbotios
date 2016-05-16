//
//  DataManager.swift
//  barbot
//
//  Created by Naveen Yadav on 3/23/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import UIKit
import Starscream

class DataManager: WebSocketDelegate {

    var socket: WebSocket!
    
    var drinkList: [Drink]?
    var ingredientList: IngredientList?
    var recipe: Recipe?
    
    typealias Payload = [String: AnyObject]
    
    // Initialize DataManager properties
    init() {
        self.socket = WebSocket(url: NSURL(string: "ws://192.168.1.36:8000?id=user_348604")!)
        self.socket.delegate = self
        self.socket.connect()
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
    
    // Retrieve JSON from local file, convert to Payload and return
    private func getJSONDataFromFile(jsonFileName: String) -> Payload {
        let filePath = NSBundle.mainBundle().pathForResource(jsonFileName, ofType:"json")
        let data = try! NSData(contentsOfFile:filePath!,
                               options: NSDataReadingOptions.DataReadingUncached)
        return getJSONFromData(data)
    }
    
    // write request to web socket
    func requestDataFromServer(command: String, args: Payload) {
        let json: Payload = [
            "type": "command",
            "command": command,
            "args": args
        ]
        
        do {
            let data: NSData = try NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
            socket.writeData(data)
        } catch {
            print("error serializing JSON: \(error)")
        }
    }
    
    // process response from web socket
    func parseResponseDataFromServer(text: String) {
        let json: Payload = getJSONDataFromServer(text)
        
        switch (json.first!.0) {
            case "ingredients":
                self.ingredientList = parseIngredientJSON(json)
            case "recipes":
                self.drinkList = parseMenuJSON(json)
            case "recipe":
                self.recipe = parseRecipeJSON(json)
            default:
                break
        }
    }
    
    // Convert JSON text to Payload and return
    private func getJSONDataFromServer(jsonTextPayload: String) -> Payload {
        let data: NSData! = jsonTextPayload.dataUsingEncoding(NSUTF8StringEncoding)
        return getJSONFromData(data)
    }
    
    // MARK: - menu.json get methods
    
    // Get recipes from local file for DrinkTableViewController's table view
    func getMenuDataFromFile(file: String) -> [Drink]? {
        let json: Payload! = getJSONDataFromFile(file)
        return parseMenuJSON(json)
    }
    
    // Parse menu JSON using Gloss
    private func parseMenuJSON(json: Payload) -> [Drink]? {
        guard let menu = Menu(json: json) else {
            print("Error initializing object")
            return nil
        }
        
        return menu.menu!
    }
    
    // MARK: - ingredients.json get methods
    
    func getIngredientDataFromFile(file: String) -> IngredientList? {
        let json: Payload = getJSONDataFromFile(file)
        return parseIngredientJSON(json)
    }
    
    private func parseIngredientJSON(json: Payload) -> IngredientList? {
        guard let ingredients = IngredientList(json: json) else {
            print("Error initializing object")
            return nil
        }
        return ingredients
    }
    
    // MARK: - recipe.json get methods
    
    func getRecipeDataFromFile(file: String) -> Recipe? {
        let json: Payload = getJSONDataFromFile(file)
        return parseRecipeJSON(json)
    }
    
    private func parseRecipeJSON(json: Payload) -> Recipe? {
        guard let recipe = Recipe(json: json) else {
            print("Error initializing object")
            return nil
        }
        
        return recipe
    }
    
    // MARK: - recipeset.json get methods
    
    // Get RecipeSet from local file for given recipe id
    func getRecipeSetDataForDrink(id: String) -> RecipeSet? {
        let json: Payload = getJSONDataFromFile(id)
        return parseRecipeSetJSON(json)
    }
    
    // Get RecipeSet from local file to display in
    // DrinkViewController
    func getRecipeSetDataFromFile(file: String) -> RecipeSet? {
        let json: Payload = getJSONDataFromFile(file)
        return parseRecipeSetJSON(json)
    }
    
    private func parseRecipeSetJSON(json: Payload) -> RecipeSet? {
        guard let recipeSet = RecipeSet(json: json) else {
            print("Error initializing object")
            return nil
        }
        
        return recipeSet
    }
    
    // MARK: Websocket Delegate Methods.
    
    func websocketDidConnect(ws: WebSocket) {
        print("websocket is connected")
        requestDataFromServer("get_recipes_for_barbot", args: ["barbot_id": "barbot_805d2a"])
        requestDataFromServer("get_ingredients_for_barbot", args: ["barbot_id": "barbot_805d2a"])
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