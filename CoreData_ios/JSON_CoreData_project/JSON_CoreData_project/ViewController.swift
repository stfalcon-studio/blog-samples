//
//  ViewController.swift
//  JSON_CoreData_project
//
//  Created by Victor Amelin on 11/22/16.
//  Copyright © 2016 Victor Amelin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        StoreManager.sharedInstance.clearStorage(type: .main, entity: Car.self)
        StoreManager.sharedInstance.clearStorage(type: .background, entity: Car.self)
        
        let json = "{\"cars\":[{\"name\":\"ZaZ\"},{\"name\":\"Lada\"},{\"name\":\"Lexus\"}]}"
        let dict = try! JSONSerialization.jsonObject(with: json.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
        
        for item in dict["cars"] as! [Any] {
            let car = StoreManager.sharedInstance.backgroundContext.insert(entity: Car.self)
            car.name = (item as? [String:Any])?["name"] as! String?
        }
        //when we save background context it will automatically save all it`s data in main context,
        //after that we can use main context for updating interface
        StoreManager.sharedInstance.saveContext(type: .background)
        
         //display cars by their names from main context
        let objects = StoreManager.sharedInstance.getMainContextObjects(entity: Car.self) as! [Car]
        print(objects.map { $0.name })
        
        //save main context by the end of your work
        StoreManager.sharedInstance.saveContext(type: .main)
    }
}

