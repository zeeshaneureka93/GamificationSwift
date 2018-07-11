//
//  Exercise+AppProperties.swift
//  CoreDirection
//
//  Created by Ahmar on 8/24/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import Foundation
import CoreData

extension Exercise   {
    
    class func deleteAllExercises() {
        CoreDataManager.deleteAll(entityName: Entity.exercise)
    }
    
    class func fetchAllExercises() -> [Exercise] {
        var exercisesArray = [Exercise]()
        exercisesArray = CoreDataManager.fetchList(entityName: Entity.exercise, predicate: nil) as! [Exercise]
        return exercisesArray
    }

    class func deleteAllExercises(workout: Workout) {
        let exercisesArray = Exercise.fetchAllExercises()
        for exercise in exercisesArray {
            if exercise.workouts?.contains(workout) ?? false {
                CoreDataManager.deleteObject(object: exercise)
            }
        }
        CoreDataStack.save()        
    }
    

    class func sync(data: [[String: Any]], workout: Workout)    {
        var exerciseList = data
        print("=============================================")
        print("sync stared")
        let entityName = Entity.exercise
        
        var newIds = [Int64]()
        var updatedIds = [Int64]()
        var insertIds = [Int64]()
        
        for i in 0..<exerciseList.count {
            
            var exerciseDictionary = exerciseList[i]
            
            let id = exerciseDictionary[K.id] as! Int64
            newIds.append(id)
            exerciseList[i] = exerciseDictionary
            
            var lastUpdated: Double = 0
            let lastUpdateValue = exerciseDictionary[K.lastUpdated]
            if  lastUpdateValue is Double   {
                lastUpdated = lastUpdateValue as! Double
            }
            else    {
                exerciseDictionary[K.lastUpdated] = lastUpdated
            }
            
            var exercise: Exercise!
            let updatePredicate = NSPredicate(format: "id == \(id) && lastUpdated != \(lastUpdated)")
            
            if CoreDataManager.ifExist(entityName: entityName, predicate: updatePredicate) {
                exerciseDictionary["image"] = NSNull()//nil
                exercise = CoreDataManager.update(object: exerciseDictionary, entityName: entityName, id: id) as! Exercise
                updatedIds.append(id)
                print("item updated: \(id) - \(String(describing: exerciseDictionary[K.name]))")
            }
            else if !CoreDataManager.ifExist(entityName: entityName, id: id)    {
                exercise = CoreDataManager.insert(object: exerciseDictionary, entityName: entityName) as! Exercise
                insertIds.append(id)
                print("item inserted: \(id) - \(String(describing: exerciseDictionary[K.name]))")
            }
            else    {
                exercise = CoreDataManager.fetchObject(entityName: entityName, id: id) as! Exercise
            }
            
            exercise.addToWorkouts(workout)
            
            if let stepsList = exerciseDictionary["steps"] as? [[String: Any]] {
                Step.sync(data: stepsList, exercise: exercise)
            }

        }

        print("=============================================")
        print("sync end")
        CoreDataStack.save()

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
