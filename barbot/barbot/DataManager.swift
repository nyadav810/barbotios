//
//  DataManager.swift
//  barbot
//
//  Created by Naveen Yadav on 3/23/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

// TODO: Uncomment websocket init and getFromServer methods when we have a server URL

import UIKit
import Starscream

class DataManager: WebSocketDelegate {

    var socket: WebSocket!
    
    var drinkList: [Drink]?
    var ingredientList: IngredientList?
    
    typealias Payload = [String: AnyObject]
    
    // Initialize DataManager properties
    init() {
        self.socket = WebSocket(url: NSURL(string: "ws://localhost:8000?id=user_348604")!)
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
    
    private func getDataFromJSONFile(jsonFileName: String) -> NSData {
        let filePath = NSBundle.mainBundle().pathForResource(jsonFileName, ofType:"json")
        let data = try! NSData(contentsOfFile:filePath!,
                               options: NSDataReadingOptions.DataReadingUncached)
        return data
    }
    
    // MARK: - menu.json get methods

//     Get recipes from server using Websocket
//    func getMenuDataFromServer(barbotId: String) -> [Drink]? {
//        socket.writeData(json)
//        
//        var menu: [Drink]?
//        socket.onText = {(text: String) in
//            let json: Payload! = self.getJSONDataFromServer(text)
//            menu = self.parseMenuJSON(json)
//        }
//        
//        return menu
//    }
    
    // Get recipes from local file for DrinkTableViewController's table view
    func getMenuDataFromFile(file: String) -> [Drink]? {
        let json: Payload! = self.getJSONDataFromFile(file)
        return self.parseMenuJSON(json)
    }
    
    // Parse menu JSON using Gloss
    private func parseMenuJSON(json: Payload) -> [Drink]? {
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
    
    // MARK: - recipeset.json get methods
    
    // Get RecipeSet from local file for given recipe id
    func getRecipeSetDataForDrink(id: String) -> RecipeSet? {
        let json: Payload = self.getJSONDataFromFile(id)
        return self.parseRecipeSetJSON(json)
    }
    
    // Get RecipeSet from local file to display in
    // DrinkViewController
    func getRecipeSetDataFromFile(file: String) -> RecipeSet? {
        let json: Payload = self.getJSONDataFromFile(file)
        return self.parseRecipeSetJSON(json)
    }
    
    private func parseRecipeSetJSON(json: Payload) -> RecipeSet? {
        guard let recipeSet = RecipeSet(json: json) else {
            print("Error initializing object")
            return nil
        }
        
        return recipeSet
    }
    
    // MARK: - ingredients.json get methods
    
//    func getIngredientDataFromServer(barbotId: String) -> IngredientList? {
//        let data: NSData = getDataFromJSONFile("get_ingredients")
//        
//        socket.writeData(data)
//    
//        var ingredientList: IngredientList?
//        self.ingredientList = self.parseIngredientJSON(self.json)
//        return ingredientList
//    }
    
    func requestIngredientDataFromServer() {
        let data: NSData = getDataFromJSONFile("get_ingredients")
        socket.writeData(data)
    }
    
    func getIngredientDataFromServer(text: String) {
        let json: Payload = self.getJSONDataFromServer(text)
        self.ingredientList = self.parseIngredientJSON(json)
    }
    
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
        self.requestIngredientDataFromServer()
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
        self.getIngredientDataFromServer(text)
    }
    
    func websocketDidReceiveData(ws: WebSocket, data: NSData) {
        print("Received data: \(data.length)")
    }
}