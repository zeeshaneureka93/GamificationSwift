//
//  CoreDataStack.swift
//  CoreDirection
//
//  Created by Yasir Ali on 7/11/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import CoreData

class CoreDataStack  {
    
    // MARK: Class Methdos
    
    class func setup()  {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1] as URL)
        _ = stack.sqlContext
        _ = stack.applicationDocumentDirectory
    }
    
    class func save()   {
        stack.saveContext()
    }
    
    class func getContext() -> NSManagedObjectContext {
        return stack.sqlContext
    }
    
    class func getStoreCoordinator() -> NSPersistentStoreCoordinator    {
        var coordinator: NSPersistentStoreCoordinator!
        if #available(iOS 10, *) {
            coordinator = stack.sqlStoreContainer.persistentStoreCoordinator
        }
        else    {
            coordinator = stack.sqlStoreCoordinator
        }
        return coordinator
    }
    
    
    fileprivate let modelName: String
    fileprivate static let stack = CoreDataStack(modelName: "CoreDirection")
    
    // MARK: - Contexts
    lazy var sqlContext: NSManagedObjectContext = {
        var context: NSManagedObjectContext!
        if #available(iOS 10, *) {
            context = self.sqlStoreContainer.viewContext
        }
        else    {
            let coordinator = self.sqlStoreCoordinator
            context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            context.persistentStoreCoordinator = coordinator
            context.undoManager = nil
        }
        return context
    }()
    
    
    // MARK: - Store Container >= iOS 10
    @available(iOS 10.0, *)
    lazy fileprivate var sqlStoreContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as Error? {
                fatalError("Unresolved error in sql persistant container: \(error)")
            }
            else {
                print("sql persistant container error: \(String(describing: error)), storeDescription: \(String(describing: storeDescription))")
            }
        }
        return container
    }()
    
    
    // MARK: - Store Coordinator < iOS 10
    
    lazy fileprivate var sqlStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentDirectory.appendingPathComponent("\(self.modelName)).sqlite")
        var failureReason = "There was an error creating or loading the application's saved data. (SQL)"
        do  {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url)
        }   catch   {
            print("sql persistant store coordinator error: \(error)")
        }
        return coordinator
    }()
    
    
    // MARK: - Helping Properties
    lazy fileprivate var applicationDocumentDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls.last!)
        return urls.last!
    }()
    
    lazy fileprivate var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "mom")
        return NSManagedObjectModel(contentsOf: modelURL!)!
    }()
    
    // MARK: - Initializer
    private init(modelName: String) {
        self.modelName = modelName
    }
    
    func saveContext()  {

        if sqlContext.hasChanges {
            print("items to be inserted: \(sqlContext.insertedObjects)")
            print("items to be updated: \(sqlContext.updatedObjects)")
            print("items to be deleted: \(sqlContext.deletedObjects)")
            
            do {
                try sqlContext.save()
            }   catch let nserror as NSError    {
                Console.log(error: "Unresolved error: \(nserror), \(nserror.userInfo)", sender: self)
            }
            catch {
                Console.log(error: "sql managedObjectContext error: \(error)", sender: self)
            }
        }
    }
}
