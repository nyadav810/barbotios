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
    
    var barbotId: String!
    var userId: String!
    
    var drinkList: [Drink]?
    var ingredientList: IngredientList?
    var recipe: Recipe?
    var drinkOrder: String = ""
    var result: String!
    
    typealias Payload = [String: AnyObject]
    
    // Initialize DataManager properties
    init() {
        self.barbotId = "barbot_805d2a"
        self.userId = "user_348604"
        
        self.socket = WebSocket(url: NSURL(string: "ws://192.168.1.36:8000?id=\(self.userId)")!)
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
            case "drink_order_id":
                self.drinkOrder = parseSingleStringJSON(json, key: "drink_order_id")
            case "result":
                self.result = parseSingleStringJSON(json, key: "result")
            default:
                break
        }
    }
    
    // Convert JSON text to Payload and return
    private func getJSONDataFromServer(jsonTextPayload: String) -> Payload {
        let data: NSData! = jsonTextPayload.dataUsingEncoding(NSUTF8StringEncoding)
        return getJSONFromData(data)
    }
    
    // MARK: - Menu get methods
    
    // Parse menu JSON using Gloss
    private func parseMenuJSON(json: Payload) -> [Drink]? {
        guard let menu = Menu(json: json) else {
            print("Error initializing object")
            return nil
        }
        
        return menu.menu!
    }
    
    // MARK: - Ingredient get methods
    
    private func parseIngredientJSON(json: Payload) -> IngredientList? {
        guard let ingredients = IngredientList(json: json) else {
            print("Error initializing object")
            return nil
        }
        return ingredients
    }
    
    // MARK: - Recipe get methods
    
    private func parseRecipeJSON(json: Payload) -> Recipe? {
        guard let recipe = Recipe(json: json) else {
            print("Error initializing object")
            return nil
        }
        
        return recipe
    }
    
    // MARK: - RecipeSet get methods
    
    private func parseRecipeSetJSON(json: Payload) -> RecipeSet? {
        guard let recipeSet = RecipeSet(json: json) else {
            print("Error initializing object")
            return nil
        }
        
        return recipeSet
    }
    
    // MARK: - Result get methods
    
    private func parseSingleStringJSON(json: Payload, key: String) -> String! {
//        guard let s: String = String(json[key]) else {
//            print("Error initializing object")
//            return ""
//        }
        return String(json[key]!)
    }
    
    // MARK: Websocket Delegate Methods.
    
    func websocketDidConnect(ws: WebSocket) {
        print("websocket is connected")
        requestDataFromServer("get_recipes_for_barbot", args: ["barbot_id": self.barbotId])
        requestDataFromServer("get_ingredients_for_barbot", args: ["barbot_id": self.barbotId])
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