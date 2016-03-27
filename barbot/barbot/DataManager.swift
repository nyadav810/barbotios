//
//  DataManager.swift
//  barbot
//
//  Created by Naveen Yadav on 3/23/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Foundation

class DataManager {
    
    let ServerURL = "/drinks.json"
    
    typealias Payload = [String: AnyObject]

    func getDrinkMenuDataFromServerWithSuccess(success: ((drinkMenuData: NSData!) -> Void)) {
        
        let url : NSURL = NSURL(string: ServerURL)!
        let rawData : NSData = NSData(contentsOfURL: url)!
        
        var json: Payload!
        do {
            json = try NSJSONSerialization.JSONObjectWithData(rawData, options: NSJSONReadingOptions()) as? Payload
        } catch {
            print(error)
        }
        
        guard let menu = json["menu"] as? Payload,
            let drinks = menu["drinks"] as? [AnyObject]
            else { return }
    }
    
    func getDrinkMenuDataFromFileWithSuccess(success: ((data: NSData) -> Void)) {
        var json: Payload!
        
        let filePath = NSBundle.mainBundle().pathForResource("drinks", ofType:"json")
        let data = try! NSData(contentsOfFile:filePath!,
                                options: NSDataReadingOptions.DataReadingUncached)
    
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? Payload
        } catch {
            print(error)
        }
        
        success(data: data)
    }
}