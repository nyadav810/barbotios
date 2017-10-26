//
//  Constants.swift
//  BarBot iOS
//
//  Created by Naveen Yadav on 10/12/17.
//  Copyright © 2017 BarBot Inc. All rights reserved.
//

import Foundation

struct Config {
    static let ipAddress = "10.0.0.5"
    static let portNumber = "8080"
    static let user: User = User.init(userId: "4aeefa", name: "panda", email: "panda@panda.com", password: "password")
}

struct WebSockets {
    struct Command {
        static let createCustomRecipe = "create_custom_recipe"
        static let getCategories = "get_categories"
        static let getCategory = "get_category"
        static let getContainersForBarbot = "get_containers_for_barbot"
        static let getIngredientsForBarbot = "get_ingredients_for_barbot"
        static let getRecipeDetails = "get_recipe_details"
        static let getRecipesForBarbot = "get_recipes_for_barbot"
        static let orderDrink = "order_drink"
        static let setContainersForBarbot = "set_containers_for_barbot"
    }
}
