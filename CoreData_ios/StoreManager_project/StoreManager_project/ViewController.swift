//
//  ViewController.swift
//  StoreManager_project
//
//  Created by Victor Amelin on 11/21/16.
//  Copyright © 2016 Victor Amelin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(storageHasChanged(note:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
        
        StoreManager.sharedInstance.clearMainStorage()
        
        StoreManager.sharedInstance.addACar(name: "BMW", hasRoof: true, numberOfWheels: 4)
        StoreManager.sharedInstance.addACar(name: "Zapor", hasRoof: false, numberOfWheels: 3)
        StoreManager.sharedInstance.addACar(name: "Fiat", hasRoof: true, numberOfWheels: 5)
        StoreManager.sharedInstance.addACar(name: "F1", hasRoof: false, numberOfWheels: 4)
        
        perform(#selector(insertAnotherCar), with: nil, afterDelay: 2.0)
        StoreManager.sharedInstance.showMainStorage()
    }
    
    func insertAnotherCar() {
        StoreManager.sharedInstance.addACar(name: "Alfa Romeo", hasRoof: true, numberOfWheels: 4)
        StoreManager.sharedInstance.showMainStorage()
    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
    
//    //MARK: Actions
//    func storageHasChanged(note: NSNotification) {
//        let inserted = note.userInfo?["inserted"]
//        let deleted = note.userInfo?["deleted"]
//        let updated = note.userInfo?["updated"]
//        
//        if let insertedSet = inserted as? Set<Car>, insertedSet.count > 0 {
//            print("INSERTED")
//            print(insertedSet.map { $0.name })
//        }
//        if let deletedSet = deleted as? Set<Car>, deletedSet.count > 0 {
//            print("DELETED")
//            print(deletedSet.map { $0.name })
//        }
//        if let updatedSet = updated as? Set<Car>, updatedSet.count > 0 {
//            print("UPDATED")
//            print(updatedSet.map { $0.name })
//        }
//    }
}









