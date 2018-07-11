//
//  CoreDataManager.swift
//  CoreDirection
//
//  Created by Yasir Ali on 7/11/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager   {
    
    //MARK:- Basic CRUD
    
    class func insert(object: [String: Any], entityName: String) -> NSManagedObject? {
        
        let context = CoreDataStack.getContext()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)!
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        
        let keys = Array(entity.attributesByName.keys)
        
        for (key, element) in object  {
            if keys.contains(key)   {
                managedObject.setValue(element, forKey: key)
            }
        }
        
        return managedObject
    }
    
    class func update(object: [String: Any], entityName: String, id: Int64, foreignKey: String = "",foreignKeyValue: Int = 0) -> NSManagedObject?  {

        //Predicate
        var predicate: NSPredicate?
        var predicateValue = ""
        
        predicateValue = String(format: "id == %ld", id)
        
        
        if foreignKey != "" {
            predicateValue.append(" && \(foreignKey) == \(foreignKeyValue)")
        }
        
            predicate = NSPredicate(format: predicateValue)
        
        return self.update(object: object, entityName: entityName, predicate:predicate!)
        
    }
    
    class func update(object: [String: Any], entityName: String, predicate: NSPredicate) -> NSManagedObject? {

        let objectToUpdate = fetchObject(entityName: entityName, predicate: predicate)
        if  objectToUpdate != nil {
            var objectDictionary = object
            objectDictionary["\(entityName)ID"] = object["id"]
            objectDictionary.removeValue(forKey: "id")
            
            let context = CoreDataStack.getContext()
            let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)!
            let keys = Array(entity.attributesByName.keys)
            
            for (key, element) in objectDictionary  {
                if keys.contains(key)   {
                    objectToUpdate!.setValue(element, forKey: key)
                }
            }
        }
        
        return objectToUpdate
    }
    
    class func delete(entityName: String, id: Int64) {
        let predicate = NSPredicate(format: "id == %ld", id)
        delete(entityName: entityName, predicate: predicate)
    }
    class func deleteObject(object : NSManagedObject){

        let context = CoreDataStack.getContext()

        context.delete(object)
        do {
            try _ = context.save()
            
        } catch {
            print("Failed to execute request: \(error)")
        }

    }
    
    class func delete(entityName: String, predicate: NSPredicate?) {
        
        let coordinator = CoreDataStack.getStoreCoordinator()
        let context = CoreDataStack.getContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try _ = coordinator.execute(request, with: context)
            
        } catch {
            print("Failed to execute request: \(error)")
        }
    }
    
    class func deleteAll(entityName: String)  {
        let context = CoreDataStack.getContext()
        let objects = fetchList(entityName: entityName, predicate: nil, sortBy: nil)
        for object in objects!   {
            context.delete(object)
        }
    }
    
    class func save(list:  [[String: Any]], entityName: String)  {
        let context = CoreDataStack.getContext()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)!
        
        var managedObjects = [NSManagedObject]()
        for object in list  {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            
            let keys = Array(entity.attributesByName.keys)
            
            for (key, element) in object  {
                if keys.contains(key)   {
                    managedObject.setValue(element, forKey: key)
                }
            }
            
            
            managedObjects.append(managedObject)
        }
    }
    
    //MARK:- Relationships
    
    class func addChildListToParent(childObjects: [[String: Any]], childEntityName: String, parentEntity: NSManagedObject) {
        
        let context = CoreDataStack.getContext()
        let entity = NSEntityDescription.entity(forEntityName: childEntityName, in: context)
        
        var managedObjects = [NSManagedObject]()
        for object in childObjects  {
            let managedObject = NSManagedObject(entity: entity!, insertInto: context)
            
            for (key, element) in object  {
                managedObject.setValue(element, forKey: key)
            }
            
            managedObjects.append(managedObject)
        }
        
    }
    
    
    //MARK:- Existing Methods
    
    class func ifExist(entityName: String, id: Int64) -> Bool {
        let predicate = NSPredicate(format: "id == %ld", id)
        return countObjects(entityName: entityName, predicate: predicate) == 1
    }
    
    class func ifExist(entityName: String, predicate: NSPredicate) -> Bool {
        return countObjects(entityName: entityName, predicate: predicate) == 1
    }
    
    class func countObjects(entityName: String, predicate: NSPredicate?) -> Int  {
        let context = CoreDataStack.getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = predicate
        var count = 0
        do {
            count = try context.count(for: fetchRequest)
        } catch  {
            print("Could not fetch: \(error)")
        }
        return count
    }
    
    //MARK:- Fetching Methods
    
    class func fetchObject(entityName: String, id: Int64 ) -> NSManagedObject?  {
        let context = CoreDataStack.getContext()
        let predicate = NSPredicate(format: "id == %ld", id)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = predicate
        do {
            let results = try context.fetch(fetchRequest)

            return results.first
        }   catch   {
            print("Could not fetch: \(error)")
        }
        return nil
    }
    
    class func fetchObject(entityName: String, predicate: NSPredicate? = nil) -> NSManagedObject?  {
        let context = CoreDataStack.getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = predicate
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        }   catch   {
            print("Could not fetch: \(error)")
        }
        return nil
    }
    
    class func fetchList(entityName: String, predicate: NSPredicate? = nil, sortBy: [(key: String, ascending: Bool)]? = nil) ->
        
        [NSManagedObject]?  {
            let context = CoreDataStack.getContext()
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
            fetchRequest.predicate = predicate
            
            if let sortedBy = sortBy    {
                var sortDescriptors = [NSSortDescriptor]()
                for sortElement in sortedBy   {
                    let sortDescriptor = NSSortDescriptor(key: sortElement.key, ascending: sortElement.ascending)
                    sortDescriptors.append(sortDescriptor)
                }
                fetchRequest.sortDescriptors = sortDescriptors
            }
            
            do {
                let results = try context.fetch(fetchRequest)
                return results
            }   catch   {
                print("Could not fetch: \(error)")
            }
            return nil
    }
}
