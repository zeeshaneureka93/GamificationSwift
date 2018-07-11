//
//  WorkoutLevel+AppProperties.swift
//  CoreDirection
//
//  Created by Ahmar on 8/23/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import Foundation
import CoreData

extension WorkoutLevel   {

    var isRecommended: Bool {
        return false
    }

    class func sync(data: [String: Any], type: String = K.recommended) ->[WorkoutLevel]   {
        var workoutLevelsList = data[K.list] as! [[String: Any]]
        print("=============================================")
        print("sync stared")
        let entityName = Entity.workoutLevel
        
        var newIds = [Int64]()
        var updatedIds = [Int64]()
        var insertIds = [Int64]()
        
        var syncedObjects = [WorkoutLevel]()

        for i in 0..<workoutLevelsList.count {
            
            var workoutLevelDictionary = workoutLevelsList[i]
            
            let id = workoutLevelDictionary[K.id] as! Int64
            newIds.append(id)
            workoutLevelsList[i] = workoutLevelDictionary
            
            var lastUpdated: Double = 0
            let lastUpdateValue = workoutLevelDictionary[K.lastUpdated]
            if  lastUpdateValue is Double   {
                lastUpdated = lastUpdateValue as! Double
            }
            else    {
                workoutLevelDictionary[K.lastUpdated] = lastUpdated
            }
            
            var workoutLevel: WorkoutLevel!
            let updatePredicate = NSPredicate(format: "id == \(id) && lastUpdated != \(lastUpdated)")
            
            if CoreDataManager.ifExist(entityName: entityName, predicate: updatePredicate) {
                workoutLevel = CoreDataManager.update(object: workoutLevelDictionary, entityName: entityName, id: id) as! WorkoutLevel
                updatedIds.append(id)
                print("item updated: \(id) - \(String(describing: workoutLevelDictionary[K.name]))")
                syncedObjects.append(workoutLevel)
            }
            else if !CoreDataManager.ifExist(entityName: entityName, id: id)    {
                workoutLevel = CoreDataManager.insert(object: workoutLevelDictionary, entityName: entityName) as! WorkoutLevel
                insertIds.append(id)
                print("item inserted: \(id) - \(String(describing: workoutLevelDictionary[K.name]))")
                syncedObjects.append(workoutLevel)
            }
            else    {
                workoutLevel = CoreDataManager.fetchObject(entityName: entityName, id: id) as! WorkoutLevel
                syncedObjects.append(workoutLevel)
            }
            
            
        }
        
        if K.recommended == type {
            let deletePredicate = NSPredicate(format: "NOT (id IN %@)", newIds)
            print(deletePredicate)
            CoreDataManager.delete(entityName: Entity.workoutLevel, predicate: deletePredicate)
        }
        
        
        print("=============================================")
        print("sync end")
        
        CoreDataStack.save()
        return syncedObjects
    }

    class func syncWith(workout: Workout, data: [String: Any])   {
        let workoutLevel = CoreDataManager.insert(object: data, entityName: Entity.workoutLevel) as! WorkoutLevel
        workout.level = workoutLevel
        CoreDataStack.save()
    }
    
    class func fetchWith(workoutLevelName : String ) -> WorkoutLevel? {
        
        var workoutLevel: WorkoutLevel?
        
        let predicate = NSPredicate(format: "code == %@",workoutLevelName)
        
        if CoreDataManager.ifExist(entityName: Entity.workoutLevel, predicate: predicate) {
            workoutLevel = CoreDataManager.fetchObject(entityName: Entity.workoutLevel, predicate: predicate) as? WorkoutLevel
        }
        
        return workoutLevel
    }
    
    class func fetchWith(workoutLevelName: String, workoutLevels: [WorkoutLevel])  -> WorkoutLevel? {
        
        var workoutLevel: WorkoutLevel?
        
        if workoutLevels.count > 0 {
            workoutLevel = workoutLevels.first { (workoutLevelObj: WorkoutLevel) -> Bool in
                return workoutLevelObj.code == workoutLevelName
            }
            if workoutLevel == nil {
                workoutLevel = WorkoutLevel.fetchWith(workoutLevelName: workoutLevelName)
            }
        }
        else {
            workoutLevel = WorkoutLevel.fetchWith(workoutLevelName: workoutLevelName)
        }
        
        return workoutLevel
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
