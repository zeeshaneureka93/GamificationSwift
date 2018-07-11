//
//  WorkoutType+AppProperties.swift
//  CoreDirection
//
//  Created by Ahmar on 8/23/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import Foundation
import CoreData

extension WorkoutType   {
    
    class func sync(data: [String: Any], type: String = K.recommended) -> [WorkoutType]   {
        var workoutTypeList = data[K.list] as! [[String: Any]]
        print("=============================================")
        print("sync stared")
        let entityName = Entity.workoutType
        
        var newIds = [Int64]()
        var updatedIds = [Int64]()
        var insertIds = [Int64]()
        
        var syncedObjects = [WorkoutType]()

        for i in 0..<workoutTypeList.count {
            
            var workoutTypeDictionary = workoutTypeList[i]
            
            let id = workoutTypeDictionary[K.id] as! Int64
            newIds.append(id)
            workoutTypeList[i] = workoutTypeDictionary
            
            var lastUpdated: Double = 0
            let lastUpdateValue = workoutTypeDictionary[K.lastUpdated]
            if  lastUpdateValue is Double   {
                lastUpdated = lastUpdateValue as! Double
            }
            else    {
                workoutTypeDictionary[K.lastUpdated] = lastUpdated
            }
            
            var workoutType: WorkoutType!
            let updatePredicate = NSPredicate(format: "id == \(id) && lastUpdated != \(lastUpdated)")
            
            if CoreDataManager.ifExist(entityName: entityName, predicate: updatePredicate) {
                workoutType = CoreDataManager.update(object: workoutTypeDictionary, entityName: entityName, id: id) as! WorkoutType
                updatedIds.append(id)
                print("item updated: \(id) - \(String(describing: workoutTypeDictionary[K.name]))")
                syncedObjects.append(workoutType)
            }
            else if !CoreDataManager.ifExist(entityName: entityName, id: id)    {
                workoutType = CoreDataManager.insert(object: workoutTypeDictionary, entityName: entityName) as! WorkoutType
                insertIds.append(id)
                print("item inserted: \(id) - \(String(describing: workoutTypeDictionary[K.name]))")
                syncedObjects.append(workoutType)
            }
            else    {
                workoutType = CoreDataManager.fetchObject(entityName: entityName, id: id) as! WorkoutType
                syncedObjects.append(workoutType)
            }

            
        }
        
        if K.recommended == type {
            let deletePredicate = NSPredicate(format: "NOT (id IN %@)", newIds)
            print(deletePredicate)
            CoreDataManager.delete(entityName: Entity.workoutType, predicate: deletePredicate)
        }
        
        
        print("=============================================")
        print("sync end")
        
        CoreDataStack.save()
        
        return syncedObjects
    }

    class func syncWith(workout: Workout, data: [String: Any])   {
        let workoutType = CoreDataManager.insert(object: data, entityName: Entity.workoutType) as! WorkoutType
        workout.type = workoutType
        CoreDataStack.save()
    }
    
    
    class func fetchWith(workoutName : String ) -> WorkoutType? {
        
        var workoutType: WorkoutType?

        let predicate = NSPredicate(format: "code == %@",workoutName)
        
        if CoreDataManager.ifExist(entityName: Entity.workoutType, predicate: predicate) {
            workoutType = CoreDataManager.fetchObject(entityName: Entity.workoutType, predicate: predicate) as? WorkoutType
        }

        return workoutType
    }
    
    class func fetchWith(workoutTypeName: String, workoutTypes: [WorkoutType])  -> WorkoutType? {
        
        var workoutType: WorkoutType?

        if workoutTypes.count > 0 {
            workoutType = workoutTypes.first { (workoutTypeObj: WorkoutType) -> Bool in
                return workoutTypeObj.name == workoutTypeName
            }
            if workoutType == nil {
                workoutType = WorkoutType.fetchWith(workoutName: workoutTypeName)
            }
        }
        else {
            workoutType = WorkoutType.fetchWith(workoutName: workoutTypeName)
        }
        
        return workoutType
    }
    
}

private struct K    {
    static let id = "id"
    static let title = "title"
    static let name = "name"
    static let imageUrl = "imageUrl"
    static let isFavorite = "isFavorite"
    static let lastUpdated = "lastUpdated"
    static let list = "list"
    static let searchResults = "searchResults"
    static let recommended = "recommended"
}
