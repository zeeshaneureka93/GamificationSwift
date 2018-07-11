//
//  Step+AppProperties.swift
//  CoreDirection
//
//  Created by Ahmar on 8/24/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import Foundation
import CoreData

extension Step   {
    
    class func sync(data: [[String: Any]], exercise: Exercise)    {
        var stepList = data
        print("=============================================")
        print("sync stared")
        let entityName = Entity.step
        
        var newIds = [Int64]()
        var updatedIds = [Int64]()
        var insertIds = [Int64]()
        
        for i in 0..<stepList.count {
            
            var stepDictionary = stepList[i]
            
            let id = stepDictionary[K.id] as! Int64
            newIds.append(id)
            stepList[i] = stepDictionary
            
            var lastUpdated: Double = 0
            let lastUpdateValue = stepDictionary[K.lastUpdated]
            if  lastUpdateValue is Double   {
                lastUpdated = lastUpdateValue as! Double
            }
            else    {
                stepDictionary[K.lastUpdated] = lastUpdated
            }
            
            var step: Step!
            let updatePredicate = NSPredicate(format: "id == \(id) && lastUpdated != \(lastUpdated)")
            
            if CoreDataManager.ifExist(entityName: entityName, predicate: updatePredicate) {
                stepDictionary["image"] = NSNull()//nil
                step = CoreDataManager.update(object: stepDictionary, entityName: entityName, id: id) as! Step
                updatedIds.append(id)
                print("item updated: \(id) - \(String(describing: stepDictionary[K.sequence]))")
            }
            else if !CoreDataManager.ifExist(entityName: entityName, id: id)    {
                step = CoreDataManager.insert(object: stepDictionary, entityName: entityName) as! Step
                insertIds.append(id)
                print("item inserted: \(id) - \(String(describing: stepDictionary[K.sequence]))")
            }
            else    {
                step = CoreDataManager.fetchObject(entityName: entityName, id: id) as! Step
                print("item fetched: \(id) - \(step.sequence)")
            }
            
            step.addToExercises(exercise)
        }
        
        print("=============================================")
        print("sync end")
        CoreDataStack.save()
        
    }
    
    
    class func fetchWith(stepId : Int64 ) -> Step {
        
        var step: Step!
        
        let predicate = NSPredicate(format: "id == \(stepId)")
        
        if CoreDataManager.ifExist(entityName: Entity.step, predicate: predicate) {
            step = CoreDataManager.fetchObject(entityName: Entity.step, predicate: predicate) as! Step
        }
        
        return step
    }
    
    class func fetchWith(stepId : Int64, steps: [Step])  -> Step {
        
        var step: Step!
        
        if steps.count > 0 {
            step = steps.first { (stepObj: Step) -> Bool in
                return stepObj.id == stepId
            }
            if step == nil {
                step = Step.fetchWith(stepId: stepId)
            }
        }
        else {
            step = Step.fetchWith(stepId: stepId)
        }
        
        return step
    }
    

    
}


private struct K    {
    static let id = "id"
    static let title = "title"
    static let name = "name"
    static let sequence = "sequence"
    static let imageUrl = "imageUrl"
    static let isFavorite = "isFavorite"
    static let lastUpdated = "lastUpdated"
    static let list = "list"
    static let searchResults = "searchResults"
    static let recommended = "recommended"
}
