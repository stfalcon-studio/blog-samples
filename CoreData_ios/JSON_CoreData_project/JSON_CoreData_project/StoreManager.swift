//
//  StoreManager.swift
//  MagicalRecord_project
//
//  Created by Victor Amelin on 11/21/16.
//  Copyright © 2016 Victor Amelin. All rights reserved.
//

import Foundation
import CoreData

enum ContextType {
    case main
    case background
}

class StoreManager: NSObject {
    fileprivate override init() {}
    static let sharedInstance = StoreManager()
    override func copy() -> Any {
        fatalError("You are not allowed to use copy method on singleton!")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //----------------------
    
    //to make sure we have only one copy
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
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
    
    func saveContext(type: ContextType) {
        let context = type == .main ? persistentContainer.viewContext : backgroundContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getMainContextObjects<T: NSManagedObject>(entity: T.Type) -> [NSManagedObject]? {
        return persistentContainer.viewContext.fetchAll(entity: entity, fetchConfiguration: nil)
    }
    
    func clearStorage<T: NSManagedObject>(type: ContextType, entity: T.Type) {
        let context = type == .main ? persistentContainer.viewContext : backgroundContext
        let objects = context.fetchAll(entity: entity, fetchConfiguration: nil)
        if let objects = objects {
            for item in objects {
                context.delete(item)
            }
        }
    }
    
    func showStorage<T: NSManagedObject>(type: ContextType, entity: T.Type) {
        let context = type == .main ? persistentContainer.viewContext : backgroundContext
        let objects = context.fetchAll(entity: entity, fetchConfiguration: nil)
        print("OBJECTS: \(objects)")
        print("COUNT: \(objects?.count)")
    }
}

//MARK: CoreData extensions
extension NSManagedObject {
    class var entityName : String {
        let components = NSStringFromClass(self)
        return components
    }
    
    class func fetchRequestObj() -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        return request
    }
    
    class func fetchRequestWithKey(key: String, ascending: Bool = true) -> NSFetchRequest<NSFetchRequestResult> {
        let request = fetchRequestObj()
        request.sortDescriptors = [NSSortDescriptor(key: key, ascending: ascending)]
        return request
    }
}

extension NSManagedObjectContext {
    func insert<T: NSManagedObject>(entity: T.Type) -> T {
        let entityName = entity.entityName
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: self) as! T
    }
    
    func fetchAll<T: NSManagedObject>(entity: T.Type, fetchConfiguration: ((NSFetchRequest<NSManagedObject>) -> Void)?) -> [NSManagedObject]? {
        let dataFetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity.entityName)
        
        fetchConfiguration?(dataFetchRequest)
        var result = [NSManagedObject]()
        do {
            result = try self.fetch(dataFetchRequest)
        } catch {
            print("Failed to fetch feed data, critical error: \(error)")
        }
        return result
    }
}












