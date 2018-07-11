//
//  AppUser+AppProperties.swift
//  CoreDirection
//
//  Created by Ahmar on 9/28/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import Foundation
import CoreData

extension AppUser   {
    
    var defaultProfile: Profile? {
        var objSelectedProfile = (self.profiles?.array as! [Profile]).first(where: { ( profile : Profile) -> Bool in
            return profile.isDefault == true
        })
        if objSelectedProfile == nil {
            objSelectedProfile = (self.profiles?.array as! [Profile]).count>0 ? (self.profiles?.array as! [Profile])[0] : nil
            objSelectedProfile?.isDefault = true
        }
        return objSelectedProfile
    }
    
    var selectedProfile: Profile? {
        var objSelectedProfile = (self.profiles?.array as! [Profile]).first(where: { ( profile : Profile) -> Bool in
            return profile.isSelected == true
        })
        if objSelectedProfile == nil {
            objSelectedProfile = self.defaultProfile
            objSelectedProfile?.isSelected = true
        }
        return objSelectedProfile
    }
    
    // Article Helpers
    var favoriteArticles: NSOrderedSet? {
        return self.selectedProfile?.favoriteArticles ?? NSOrderedSet()
    }
    
    var recommendedArticles: NSSet? {
        return self.selectedProfile?.recommendedArticles ?? NSSet()
    }
    
    var searchedArticles: NSOrderedSet? {
        return self.selectedProfile?.searchedArticles ?? NSOrderedSet()
    }
    


    // Workout Helpers
    var favoriteWorkouts: NSOrderedSet? {
        return self.selectedProfile?.favoriteWorkouts ?? NSOrderedSet()
    }
    
    var historyWorkouts: NSSet? {
        return self.selectedProfile?.historyWorkouts ?? NSSet()
    }
    
    var recommendedWorkouts: NSSet? {
        return self.selectedProfile?.recommendedWorkouts ?? NSSet()
    }
    
    var searchedWorkouts: NSOrderedSet? {
        return self.selectedProfile?.searchedWorkouts ?? NSOrderedSet()
    }
    



}

