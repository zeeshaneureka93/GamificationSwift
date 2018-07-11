//
//  Level+AppProperties.swift
//  CoreDirection
//
//  Created by Ahmar on 9/5/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import Foundation
import CoreData

extension Level   {
    
    class func fetchLevelsForType(type: String) -> [Level] {
        
        var testArray = [Level]()
        testArray = self.fetchAllLevels()
        
        let filterArray = testArray.filter { (obj : Level) -> Bool in
            return obj.type == type
        }
        
        let sortedLevelsList = filterArray.sorted(by: { ($0).totalPoints < ($1).totalPoints })
        return sortedLevelsList
    }
    
    class func fetchAllLevels() -> [Level] {
        
        var levelsArray = [Level]()
        levelsArray = CoreDataManager.fetchList(entityName: Entity.level, predicate: nil) as! [Level]
        return levelsArray
    }
    
    class func fitnessPointsForAllUnlcokedLevels() -> (totalFitnessPoints : Int64 ,fitnessName: String ){
      
        // Here fetch all levels and calculate fitness points only for unlocked levels
        
        var allLevels = [Level]()
        var fitnessName = ""
        allLevels = self.fetchAllLevels()
        var totalFitnessPoints = 0 as Int64
        
        let filterFitnessLevels = allLevels.filter { (currentLevel: Level) -> Bool in
            return currentLevel.type == "FITNESS"
        }
        
        if filterFitnessLevels.count > 0 {
            
            let sortedFitnessLevels = filterFitnessLevels.sorted(by: { ($0).totalPoints < ($1).totalPoints })
            
            for index in 0..<sortedFitnessLevels.count {
                
                if index == 0 {
                    totalFitnessPoints += sortedFitnessLevels[index].earnedPoints
                    fitnessName = sortedFitnessLevels[index].name!

                }
                else {
                    
                    // for locked levels total
//                    let previousLevel = sortedFitnessLevels[index-1]
//                    if previousLevel.earnedPoints == previousLevel.totalPoints {
//                        totalFitnessPoints += previousLevel.earnedPoints
//                        fitnessName = sortedFitnessLevels[index].name!
//                    }
                    
                    // for unlock levels total
                    if sortedFitnessLevels[index].earnedPoints > 0 {
                        totalFitnessPoints += sortedFitnessLevels[index].earnedPoints
                        fitnessName = sortedFitnessLevels[index].name!
                    }
                    

                }
            }
        }
        return (totalFitnessPoints,fitnessName)
    }
    
    class func deleteAllLevels() {
        
        CoreDataManager.deleteAll(entityName: Entity.level)
    }
    
    class func sync(data: [String: Any], type: String = K.levels)    {
        
        var levelList = data[K.list] as! [[String: Any]]
        if type == K.badgesAndLevels {
            levelList = data[K.badgesAndLevels] as! [[String: Any]]
        }
        print("=============================================")
        print("sync stared")
        let entityName = Entity.level
        
        if levelList.count > 0 {
            self.deleteAllLevels()
        }
        
        var uniqueTypes = [String]()
        
        for i in 0..<levelList.count {
            
            var levelDictionary = levelList[i]
//            if i > 0 {
//                if type == K.levels {
//                    if var earnedPoints = levelDictionary["level_earned_points"] as? Int , earnedPoints > 0 {
//                        var previousLevelDictionary = levelList[i-1]
//                        let previousLevelEarnedPoints = previousLevelDictionary["level_earned_points"] as! Int
//                        earnedPoints = earnedPoints - previousLevelEarnedPoints
//                        levelDictionary["level_earned_points"] = earnedPoints
//                    }
//                }
//            }
            levelDictionary = GamificationParser.parseLevelFor(dict: levelDictionary, type: type)
            
            if !uniqueTypes.contains(levelDictionary["type"] as! String) {
                uniqueTypes.append(levelDictionary["type"] as! String)
            }
            
            _ = CoreDataManager.insert(object: levelDictionary, entityName: entityName) as! Level
        }
        
        print("=============================================")
        print("sync end")
        
        CoreDataStack.save()
        syncFitness(uniqueTypes: uniqueTypes)
    }
    
    class func syncFitness(uniqueTypes: [String]) {
        
        //        All Fitness Levels
        //        Newbie
        //        Novice
        //        Rookie
        //        Beginner
        //        Talented
        //        Skilled
        //        Intermediate
        //        Skillful
        //        Seasoned
        //        Proficient
        //        Experienced
        //        Advanced
        //        Senior
        //        Expert
        var levelJsonList = [[String: Any]]()
        let fitnessLevels = [NSLocalizedString("Novice", comment:""),
                             NSLocalizedString("Rookie", comment:""),
                             NSLocalizedString("Intermediate", comment:""),
                             NSLocalizedString("Pro", comment:"")]
        var totalLevels = 0
        
        
        var multipleListLevels: [[Level]] = []
        
        for type in uniqueTypes {
            
            let filteredLevels = self.fetchLevelsForType(type: type)
            
            if filteredLevels.count > totalLevels {
                totalLevels = filteredLevels.count
            }
            multipleListLevels.append(filteredLevels)
        }
        
        for index in 0..<totalLevels {
            
            var levelDict = [String:Any]()
            
            levelDict["level_id"] = "\(index)"
            levelDict["is_latest_level_earn"] = Int64(0)
            levelDict["level_title"] = fitnessLevels[index]
            levelDict["level_sub_title"] = fitnessLevels[index]
            levelDict["level_name"] = fitnessLevels[index]
            levelDict["name_en"] = "FITNESS"
            levelDict["level_desc"] = fitnessLevels[index]
            levelDict["level_img"] = ""
            levelDict["type"] = "FITNESS"
            
            var earnedPoints = 0 as Int64
            var totalPoints = 0 as Int64
            
            for listLevels in multipleListLevels {
                
                let currentLevel = listLevels[index] as Level
                
                earnedPoints +=  currentLevel.earnedPoints
                totalPoints  +=  currentLevel.totalPoints
            }
            
            levelDict["level_earned_points"] = String(earnedPoints)
            levelDict["level_total_points"] = String(totalPoints)
            
            levelJsonList.append(levelDict)
        }
        
        
        print("=============================================")
        print("sync stared")
        let entityName = Entity.level
        
        
        for i in 0..<levelJsonList.count {
            
            var levelDictionary = levelJsonList[i]
            
            levelDictionary = GamificationParser.parseLevelFor(dict: levelDictionary, type: K.levels)
            _ = CoreDataManager.insert(object: levelDictionary, entityName: entityName) as! Level
        }
        
        print("=============================================")
        print("sync end")
        CoreDataStack.save()
    }
}

private struct K    {
    static let id = "id"
    static let title = "title"
    static let imageUrl = "imageUrl"
    static let isFavorite = "isFavorite"
    static let lastUpdated = "lastUpdated"
    static let list = "levels"
    
    static let levels = "levelsInfo"
    static let badgesAndLevels = "badges_levels"
    
}

