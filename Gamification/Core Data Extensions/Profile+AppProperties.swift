//
//  Profile+AppProperties.swift
//  CoreDirection
//
//  Created by Ahmar on 9/28/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import Foundation
import CoreData

extension Profile   {

    class func fetchAllProfiles() -> [Profile] {
        var profilesArray = [Profile]()
        profilesArray = CoreDataManager.fetchList(entityName: Entity.profile, predicate: nil) as! [Profile]
        return profilesArray
    }

    class func resetAllProfileSelection() {
        let existingProfilesList = Profile.fetchAllProfiles()
        for existingProfileObj in existingProfilesList {
            existingProfileObj.isSelected = false
            existingProfileObj.isDefault = false
            existingProfileObj.user = nil
        }
        CoreDataStack.save()
    }
    
    class func sync(data: [String: Any])     {
        var profilesList = data[K.list] as! [[String: Any]]
        print("=============================================")
        print("sync stared")
        let entityName = Entity.profile
        var newIds = [Int64]()
        var updatedIds = [Int64]()
        var insertIds = [Int64]()
        var fetchedIds = [Int64]()
        for i in 0..<profilesList.count {
            var profileDictionary = profilesList[i]
            profileDictionary = parseProfileFor(dict: profileDictionary)
            let id = profileDictionary[K.id] as! Int64
            newIds.append(id)
            profilesList[i] = profileDictionary
            var profile: Profile!
            let updatePredicate = NSPredicate(format: "id == \(id)")
            if CoreDataManager.ifExist(entityName: entityName, predicate: updatePredicate) {
                profileDictionary["image"] = NSNull()//nil
                profile = CoreDataManager.update(object: profileDictionary, entityName: entityName, id: id) as! Profile
                profile.user = nil
                
                updatedIds.append(id)
                print("item updated: \(id) - \(String(describing: profileDictionary[K.title]))")
                
            } else if !CoreDataManager.ifExist(entityName: entityName, id: id)    {
                profile = CoreDataManager.insert(object: profileDictionary, entityName: entityName) as! Profile
                insertIds.append(id)
                print("item inserted: \(id) - \(String(describing: profileDictionary[K.title]))")
            } else {
                profile = CoreDataManager.fetchObject(entityName: entityName, id: id) as! Profile
                print("item fetched: \(id) - \(String(describing: profileDictionary[K.title]))")
                fetchedIds.append(id)
            }
            let isDefault = profileDictionary["isDefault"] as! Bool
            print("id=\(id), isDefault=\(isDefault)")
            profile.user = SessionManager.user
        }
        
        print("=============================================")
        print("sync end")
        
        CoreDataStack.save()
    }
    
    class func parseProfileFor(dict: [String: Any]?) -> [String: Any] {
        var profileDict = [String:Any]()
        profileDict["id"] = Int64(dict?["key_id"] as? Int ?? 0)
        profileDict["name"] = (dict?["company_name"] as? String ?? "")
        profileDict["imageUrl"] = (dict?["company_logo"] as? String ?? "")
        profileDict["companyId"] = Int64(dict?["company_id"] as? Int ?? 0)
        profileDict["keyType"] = (dict?["key_type"] as? String ?? "")
        profileDict["isDefault"] = ((profileDict["keyType"] as! String) == "Default") ? true : false
        return profileDict
    }

}


private struct K    {
    static let id = "id"
    static let title = "name"
    static let imageUrl = "imageUrl"
    static let lastUpdated = "lastUpdated"
    static let list = "user_profiles"
}
