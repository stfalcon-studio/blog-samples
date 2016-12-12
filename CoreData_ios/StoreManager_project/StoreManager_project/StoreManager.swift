//
//  StoreManager.swift
//  MagicalRecord_project
//
//  Created by Victor Amelin on 11/21/16.
//  Copyright © 2016 Victor Amelin. All rights reserved.
//

import Foundation
import CoreData

class StoreManager: NSObject {
    fileprivate override init(){}
    static let sharedInstance = StoreManager()
    override func copy() -> Any {
        fatalError("You are not allowed to use copy method on singleton!")
    }

    //----------------------
    
    fileprivate lazy var fetchRequest: NSFetchRequest<Car> = {
        let request = NSFetchRequest<Car>()
        request.entity = Car.entity()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return request
    }()
    
    fileprivate lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveMainContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func clearMainStorage() {
        var cars: [Car]?
        do {
            cars = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Storage reading error!")
        }
        if let cars = cars {
            for item in cars {
                persistentContainer.viewContext.delete(item)
            }
        }
    }
    
    func addACar(name: String, hasRoof: Bool, numberOfWheels: Int) {
        //add data to background context
        let context = persistentContainer.newBackgroundContext()
        let car = NSEntityDescription.insertNewObject(forEntityName: "Car", into: context) as! Car
        car.name = name
        car.numberOfWheels = Int16(numberOfWheels)
        car.hasRoof = hasRoof
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func showMainStorage() {
        var cars: [Car]?
        do {
            cars = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Storage reading error!")
        }
        print("CARS: \(cars?.map { $0.name! })")
    }
}























