//
//  WebSocketHandler.swift
//  BarBot iOS
//
//  Created by Naveen Yadav on 10/13/17.
//  Copyright © 2017 BarBot Inc. All rights reserved.
//

import Gloss
import Starscream

class WebSocketHandler: WebSocketDelegate {
    var socket: WebSocket!
    var jsonSerializer: GlossJSONSerializer
    
    init(url: String) {
        jsonSerializer = GlossJSONSerializer.init()
        socket = WebSocket(url: URL(string: url)!)
        socket.delegate = self
    }
    
    func openConnection() -> Bool {
        socket.connect()
        
        while !socket.isConnected {
            sleep(10)
        }
        
        return socket.isConnected
    }
    
    func closeConnection() -> Bool {
        socket.disconnect()
        
        while socket.isConnected {
            sleep(10)
        }
        
        return true
    }
    
    func sendMessage(message: Message) {
        if socket.isConnected {
            do {
                let data: Data = try JSONSerialization.data(withJSONObject: message.toJSON()!, options: .prettyPrinted)
                socket.write(data: data)
            } catch {
                print("error serializing JSON: \(error)")
            }
        }
    }
    
    func handleResponse(_ message: Message) {
        switch message.command {
        case WebSockets.Command.createCustomRecipe:
            guard let recipe: Recipe = Recipe(json: message.data)! else {
                print("Error initializing object")
            }
        case WebSockets.Command.getCategories:
            guard let categoryList: CategoryList = CategoryList(json: message.data)! else {
                print("Error initializing object")
            }
        case WebSockets.Command.getCategory:
            guard let category: Category = Category(json: message.data)! else {
                print("Error initializing object")
            }
        case WebSockets.Command.getContainersForBarbot:
            guard let containers: ContainerList = ContainerList(json: message.data)! else {
                print("Error initializing object")
            }
        case WebSockets.Command.getIngredientsForBarbot:
            guard let ingredientList: IngredientList = IngredientList(json: message.data)! else {
                print("Error initializing object")
            }
        case WebSockets.Command.getRecipeDetails:
            guard let recipe: Recipe = Recipe(json: message.data)! else {
                print("Error initializing object")
            }
        case WebSockets.Command.getRecipesForBarbot:
            guard let recipeList: RecipeList = RecipeList(json: message.data)! else {
                print("Error initializing object")
            }
        case WebSockets.Command.orderDrink:
            guard let drinkOrder: DrinkOrder = DrinkOrder(json: message.data)! else {
                print("Error initializing object")
            }
        case WebSockets.Command.setContainersForBarbot:
            guard let result: String = message.result! else {
                print("Error initializing object")
            }
        default:
            print("Unknown WebSocket Response for \(message.command)")
        }
    }
    
    // MARK: - WebSocket Delegate Methods
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocket is disconnected")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received data: \(data.count)")
        
        let json: JSON = jsonSerializer.json(from: data, options: JSONSerialization.ReadingOptions.mutableContainers)!
        let message: Message = Message(json: json)!
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("Received text: \(text)")
    }
}
