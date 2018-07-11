//
//  Workout+AppProperties.swift
//  CoreDirection
//
//  Created by Ahmar on 8/23/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import Foundation
import CoreData

extension Workout   {
    
    var isFavorite: Bool    {
        return SessionManager.user!.selectedProfile != nil ? (self.favoriteProfiles?.contains(SessionManager.user!.selectedProfile!))! : false
    }
    
    var isRecommended: Bool {
        return SessionManager.user!.selectedProfile != nil ? (self.recommendedProfiles?.contains(SessionManager.user!.selectedProfile!))! : false
    }
    
    var isHistory: Bool    {
        return SessionManager.user!.selectedProfile != nil ? (self.historyProfiles?.contains(SessionManager.user!.selectedProfile!))! : false
    }
    
    func addToFavorite() {
        SessionManager.user!.selectedProfile != nil ? self.addToFavoriteProfiles(SessionManager.user!.selectedProfile!) : print("unable to add to favorite")
    }
    
    func removeFromFavorite() {
        SessionManager.user!.selectedProfile != nil ? self.removeFromFavoriteProfiles(SessionManager.user!.selectedProfile!) : print("unable to remove from favorite")
    }

    func removeFromRecommended()    {
        SessionManager.user!.selectedProfile != nil ? self.removeFromRecommendedProfiles(SessionManager.user!.selectedProfile!) : print("unable to remove from recommended")
    }
    
    func addToRecommended()    {
        SessionManager.user!.selectedProfile != nil ? self.addToRecommendedProfiles(SessionManager.user!.selectedProfile!) : print("unable to add to recommended")
    }
    
    func addToHistory() {
        SessionManager.user!.selectedProfile != nil ? self.addToHistoryProfiles(SessionManager.user!.selectedProfile!) : print("unable to add to history")
    }
    
    func removeFromHistory() {
        SessionManager.user!.selectedProfile != nil ? self.removeFromHistoryProfiles(SessionManager.user!.selectedProfile!) : print("unable to remove from history")
    }
    
    
    func addToSearchResults()    {
        SessionManager.user!.selectedProfile != nil ? self.addToSearchedProfiles(SessionManager.user!.selectedProfile!) : print("unable to add to search results")
    }
    
    func removeFromSearchResults()    {
        SessionManager.user!.selectedProfile != nil ? self.removeFromSearchedProfiles(SessionManager.user!.selectedProfile!) : print("unable to add to search results")
    }
    
    class func deleteSearchResults() {
        SessionManager.user?.selectedProfile?.searchedWorkouts = nil
    }
    
    public var favoriteImage: UIImage {
        return (isFavorite ? #imageLiteral(resourceName: "favorite") : #imageLiteral(resourceName: "unFavorite"))
    }
    
    
    class func syncWith(workoutTypes: [WorkoutType], workoutLevels: [WorkoutLevel], data: [String: Any], type: String = K.recommended)    {
        var workoutsList = data[K.list] as! [[String: Any]]
        print("=============================================")
        print("sync stared")
        let entityName = Entity.workout
        
        var newIds = [Int64]()
        var updatedIds = [Int64]()
        var insertIds = [Int64]()
        
        for i in 0..<workoutsList.count {
            
            var workoutDictionary = workoutsList[i]
            
            let id = workoutDictionary[K.id] as! Int64
            newIds.append(id)
            workoutsList[i] = workoutDictionary
            
            var lastUpdated: Double = 0
            let lastUpdateValue = workoutDictionary[K.lastUpdated]
            if  lastUpdateValue is Double   {
                lastUpdated = lastUpdateValue as! Double
            }
            else    {
                workoutDictionary[K.lastUpdated] = lastUpdated
            }
            let workoutTypeName = workoutDictionary["type"] as! String
            let workoutLevelName = workoutDictionary["level"] as! String

            if type == K.history {
                workoutDictionary["isHistory"] = true
            }

            
            var workout: Workout!
            let predicateValue =  String(format:"id == \(id) && lastUpdated != \(lastUpdated)")
            
            let updatePredicate = NSPredicate(format:predicateValue)
            
            
            if CoreDataManager.ifExist(entityName: entityName, predicate: updatePredicate) {
                workoutDictionary["image"] = NSNull()//nil
                workout = CoreDataManager.update(object: workoutDictionary, entityName: entityName, id: id) as! Workout
                updatedIds.append(id)
                workout.level = nil
                workout.type = nil
                // for checking/downloading exercises again
                workout.status = false
                workout.exercises = []
                print("item updated: \(id) - \(String(describing: workoutDictionary[K.name]))")
                
            }
            else if !CoreDataManager.ifExist(entityName: entityName, id: id)    {
                workout = CoreDataManager.insert(object: workoutDictionary, entityName: entityName) as! Workout
                insertIds.append(id)
                
                print("item inserted: \(id) - \(String(describing: workoutDictionary[K.name]))")
            }
            else    {
                workout = CoreDataManager.fetchObject(entityName: entityName, id: id) as! Workout
            }
            
            
            // Check and insert Workout Type for workout Name
            let workoutType = WorkoutType.fetchWith(workoutTypeName: workoutTypeName, workoutTypes: workoutTypes)
            workout.type = workoutType

            
            // Check and insert Workout Level for workout Name
            let workoutLevel = WorkoutLevel.fetchWith(workoutLevelName: workoutLevelName, workoutLevels: workoutLevels)
            workout.level = workoutLevel
            
            
            let isFavorite = workoutDictionary["isFavorite"] as! Bool
            print("id=\(id), isFavorite=\(isFavorite))")
            if isFavorite {
                workout.addToFavorite()
            }
            else {
                workout.removeFromFavorite()
            }
            
            if type == K.recommended  {
                workout.addToRecommended()
            }
            else if type == K.searchResults {
                workout.addToSearchResults()
            }

            if type == K.history  {
                workout.addToHistory()
            }
            
        }
        
        // updating Workouts against selected profile and if workout have no any recommended profile, then remove from DB
        
        if K.recommended == type {
            
            let recommenedList = SessionManager.user!.recommendedWorkouts?.allObjects as! [Workout]
            for recommendedWorkout in recommenedList {
                
                if !newIds.contains(recommendedWorkout.id) {
                    recommendedWorkout.removeFromRecommended()
                    recommendedWorkout.removeFromFavorite()
                    recommendedWorkout.removeFromHistory()
                    recommendedWorkout.removeFromSearchResults()

                    if recommendedWorkout.recommendedProfiles?.count == 0 {
                        CoreDataManager.deleteObject(object: recommendedWorkout)
                    }
                }
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
    static let history = "history"

}
