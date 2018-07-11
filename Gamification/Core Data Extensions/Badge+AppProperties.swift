//
//  Badge+AppProperties.swift
//  CoreDirection
//
//  Created by Ahmar on 9/5/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import Foundation
import CoreData

extension Badge {
    
    var isLockedBadge: Bool    {
        return self.lockedUsers?.contains(SessionManager.user!) ?? false
    }
    
    func addToLockedBadge() {
        self.addToLockedUsers(SessionManager.user!)
    }
    
    func removeFromLockedBadge() {
        self.removeFromLockedUsers(SessionManager.user!)
    }
    
    var isUnLockedBadge: Bool    {
        return self.unlockedUsers?.contains(SessionManager.user!) ?? false
    }
    
    func addToUnlockedBadge() {
        self.addToUnlockedUsers(SessionManager.user!)
    }
    
    func removeFromUnlockedBadge() {
        self.removeFromUnlockedUsers(SessionManager.user!)
    }
    
    class func fetchAllBadges() -> [Badge]{
        
        var badgesArray = [Badge]()
        badgesArray = CoreDataManager.fetchList(entityName: Entity.badge, predicate: nil) as! [Badge]
        return badgesArray
    }
    
    class func lockAllBadges() {
        var badgesArray = [Badge]()
        badgesArray = CoreDataManager.fetchList(entityName: Entity.badge, predicate: nil) as! [Badge]
        badgesArray.forEach { (currentBadge: Badge) in
            currentBadge.unlockedUsers = nil//  removeFromUnlockedBadge()
            currentBadge.lockedUsers = nil  //addToLockedBadge()
        }
    }

    
    class func deleteAllBadges() {
        CoreDataManager.deleteAll(entityName: Entity.badge)
    }
    
    class func sync(data: [String: Any], type: String = K.badges)    {

        var badgeList = data[K.lockedBadges] as! [[String: Any]]
        let badgeListUnlocked = data[K.unlockedBadges] as! [[String: Any]]
        badgeList = badgeList + badgeListUnlocked
        if type == K.badgesAndLevels {
            badgeList = data[K.badgesAndLevels] as! [[String: Any]]
        }
        
        // for testing purpose
//        if badgeList.count > 0 {
//            deleteAllBadges()
//        }
//        lockAllBadges()
        
        print("=============================================")
        print("sync stared")
        let entityName = Entity.badge
        
        
        for i in 0..<badgeList.count {
            
            var badgeDictionary = badgeList[i]
            badgeDictionary = GamificationParser.parseBadgeFor(dict: badgeDictionary, type: type)
            
            var badge: Badge!
            let badgeID = badgeDictionary["id"] as! Int64
            let priority = badgeDictionary["priority"] as! Int64
            let imageUrl = badgeDictionary["imageUrl"] as! String


            let updateImagePredicate = NSPredicate(format: "id == \(badgeID) && imageUrl != %@",imageUrl)
            let updatePriorityPredicate = NSPredicate(format: "id == \(badgeID) && priority != \(priority)",imageUrl)

            if CoreDataManager.ifExist(entityName: entityName, predicate: updateImagePredicate) {
                badgeDictionary["image"] = NSNull()//nil
                badge = CoreDataManager.update(object: badgeDictionary, entityName: entityName, id: badgeID) as! Badge
            }
            else if CoreDataManager.ifExist(entityName: entityName, predicate: updatePriorityPredicate) {
                badge = CoreDataManager.update(object: badgeDictionary, entityName: entityName, id: badgeID) as! Badge
            }
            else if !CoreDataManager.ifExist(entityName: entityName, id: badgeID)    {
                badge = CoreDataManager.insert(object: badgeDictionary, entityName: entityName) as! Badge
            }
            else    {
                badge = CoreDataManager.fetchObject(entityName: entityName, id: badgeID) as! Badge
            }
            
            let userID = badgeDictionary["user_id"] as! Int
           
            if userID != 0 {
                badge.removeFromLockedBadge()
                badge.addToUnlockedBadge()
            }
            else {
                badge.removeFromUnlockedBadge()
                badge.addToLockedBadge()
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
    static let imageUrl = "imageUrl"
    static let isFavorite = "isFavorite"
    static let lastUpdated = "lastUpdated"

    static let badges = "badgesInfo"
    static let badgesAndLevels = "badges_levels"
    
    static let lockedBadges = "lockedbadges"
    static let unlockedBadges = "unlockedbadges"
    
}

