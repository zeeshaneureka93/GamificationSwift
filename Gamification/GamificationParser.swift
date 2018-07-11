//
//  GamificationParser.swift
//  CoreDirection
//
//  Created by Ahmar on 9/5/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import Foundation

class GamificationParser {
    
    class func parseLevelFor(dict: [String: Any]?, type: String = ResponseType.levels) -> [String: Any] {
        
        var levelDict = [String:Any]()
        
        if type == ResponseType.levels {
            levelDict["id"] = Int64((dict?["level_id"] as? String  ?? "0")!)
            levelDict["earnedPoints"] = Int64((dict?["level_earned_points"] as? String ?? "0")!)
            levelDict["totalPoints"] = Int64((dict?["level_total_points"] as? String ?? "0")!)
            levelDict["isEarned"] = (dict?["is_latest_level_earn"] as? Int ?? 0)
            
            levelDict["title"] = (dict?["level_title"] as? String ?? "")!
            levelDict["subTitle"] = (dict?["level_sub_title"] as? String ?? "")!
            levelDict["name"] = (dict?["level_name"] as? String ?? "")!
            levelDict["name_en"] = (dict?["name_en"] as? String ?? "")!
            levelDict["desc"] = (dict?["level_desc"] as? String ?? "")!
            
            levelDict["imageUrl"] = (dict?["level_img"] as? String ?? "")!
            
            let name : String = (dict?["name_en"] as? String ?? "")
            var fullNameArr = name.components(separatedBy: "_")
            let typeName: String = fullNameArr[0]
            levelDict["type"] = typeName
            
        }
        else if type == ResponseType.badgesAndLevels {
            levelDict["id"] = Int64((dict?["id"] as? String  ?? "0")!)
            levelDict["name"] = Int64((dict?["name"] as? String ?? "")!)
            levelDict["totalPoints"] = Int64((dict?["points"] as? String ?? "0")!)
            levelDict["imageUrl"] = (dict?["image"] as? String ?? "")!
        }
        return levelDict
        
    }
    
    class func parseActionFor(dict: [String: Any]?, type: String = ResponseType.action) -> [String: Any] {
        
        var actionDict = [String:Any]()
        
        actionDict["id"] = Int64((dict?["button_id"] as? String  ?? "0")!)
        actionDict["points"] = Int64((dict?["points"] as? String ?? "0")!)
        actionDict["type"] = Int64((dict?["action_type"] as? String ?? "0")!)
        actionDict["name"] = (dict?["identifier"] as? String ?? "")
        
        return actionDict
    }
    
    class func parseBadgeFor(dict: [String: Any]?, type: String = ResponseType.badges) -> [String: Any] {
        var badgeDict = [String:Any]()
        
        if  type == ResponseType.badges {
            
            badgeDict["id"] = Int64((dict?["badge_id"] as? String ?? "0")!)
            badgeDict["name"] = (dict?["name"] as? String ?? "")
            badgeDict["name_en"] = (dict?["name_en"] as? String ?? "")
            badgeDict["desc"] = (dict?["desc"] as? String ?? "")
            badgeDict["imageUrl"] = (dict?["image_url"] as? String ?? "")
            badgeDict["user_id"] = dict?["user_id"] as? Int ?? 0
            
            let name : String = (dict?["name_en"] as? String ?? "")
            var fullNameArr = name.components(separatedBy: "_")
            let typeName: String = fullNameArr[0]
            badgeDict["type"] = typeName
            
            badgeDict["priority"] = Int64(0)
            badgeDict["points"] = Int64(0)

            badgeDict["points"] = Int64(dict?["points"] as? Int ?? 0)

            if fullNameArr.count > 1 {
                
                let priority = Int64(fullNameArr.last!)
                if let value = priority {
                    badgeDict["priority"] = value
                }
            }
            
            // Unlocked activity have user id, so we are assigning 0 priority
            if badgeDict["type"] as? String == "ACTIVITY" {
                if badgeDict["user_id"] as? Int == 0 {
                    badgeDict["priority"] = Int64(1)

                }
                else {
                    badgeDict["priority"] = Int64(0)
                }
            }
            
        }
        else if type == ResponseType.badgesAndLevels {
            
            badgeDict["id"] = Int64((dict?["id"] as? String ?? "0")!)
            badgeDict["name"] = (dict?["name"] as? String ?? "")
            badgeDict["imageUrl"] = (dict?["image"] as? String ?? "")
            badgeDict["points"] = Int64((dict?["points"] as? String ?? "0")!)
            badgeDict["is_badge"] = (dict?["is_badge"] as? Int ?? 0)
            
        }
        
        return badgeDict
    }
    
}


private struct ResponseType    {
    static let action = "action"
    static let badges = "badgesInfo"
    static let levels = "levelsInfo"
    static let badgesAndLevels = "badges_levels"
    
}

