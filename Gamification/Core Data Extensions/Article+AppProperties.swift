//
//  Article+AppProperties.swift
//  CoreDirection
//
//  Created by Yasir Ali on 7/5/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import Foundation
import CoreData

extension Article   {
    
    var isFavorite: Bool    {
        return SessionManager.user!.selectedProfile != nil ? (self.favoriteProfiles?.contains(SessionManager.user!.selectedProfile!))! : false

    }
    
    var isRecommended: Bool {
        return SessionManager.user!.selectedProfile != nil ? (self.recommendedProfiles?.contains(SessionManager.user!.selectedProfile!))! : false
        
    }
    
    func addToFavorite() {
        SessionManager.user!.selectedProfile != nil ? self.addToFavoriteProfiles(SessionManager.user!.selectedProfile!) : print("unable to add to favorite")
    }
    
    func removeFromFavorite() {
        SessionManager.user!.selectedProfile != nil ? self.removeFromFavoriteProfiles(SessionManager.user!.selectedProfile!) : print("unable to remove from favorite")
    }
    
    func addToRecommended()    {
        SessionManager.user!.selectedProfile != nil ? self.addToRecommendedProfiles(SessionManager.user!.selectedProfile!) : print("unable to remove from favorite")
    }
    
    func removeFromRecommended()    {
        SessionManager.user!.selectedProfile != nil ? self.removeFromRecommendedProfiles(SessionManager.user!.selectedProfile!) : print("unable to remove from recommended")
    }
    
    func addToSearchResults()    {
        SessionManager.user!.selectedProfile != nil ? self.addToSearchedProfiles(SessionManager.user!.selectedProfile!) : print("unable to remove from favorite")
    }
    
    var isRead: Bool    {
        return SessionManager.user != nil ? self.readUsers?.contains(SessionManager.user!) ?? false : false
    }
    
    
    func addToReadList() {
        SessionManager.user != nil ? SessionManager.user!.addToArticlesRead(self) : print("unable to add to read list")
        CoreDataStack.save()
    }
    
    func removeFromReadList() {
        SessionManager.user != nil ? SessionManager.user!.addToArticlesRead(self) : print("unable to add to read list")
        CoreDataStack.save()
    }
    

    
    public var favoriteImage: UIImage {
        return (isFavorite ? #imageLiteral(resourceName: "favorite") : #imageLiteral(resourceName: "unFavorite"))
    }
    
    class func deleteSearchResults() {
        SessionManager.user?.selectedProfile?.searchedArticles = nil
    }
    
    class func sync(data: [String: Any], type: String = K.recommended)    {
        var articlesList = data[K.list] as! [[String: Any]]
        print("=============================================")
        print("sync stared")
        let entityName = Entity.article
        
        var newIds = [Int64]()
        var updatedIds = [Int64]()
        var insertIds = [Int64]()
        
        for i in 0..<articlesList.count {
            
            var articleDictionary = articlesList[i]
            
            let id = articleDictionary[K.id] as! Int64
            newIds.append(id)
            articlesList[i] = articleDictionary
            
            var lastUpdated: Double = 0
            let lastUpdateValue = articleDictionary[K.lastUpdated]
            if  lastUpdateValue is Double   {
                lastUpdated = lastUpdateValue as! Double
            }
            else {
                articleDictionary[K.lastUpdated] = lastUpdated
            }
            
            var article: Article!
            let updatePredicate = NSPredicate(format: "id == \(id) && lastUpdated != \(lastUpdated)")
            
            if CoreDataManager.ifExist(entityName: entityName, predicate: updatePredicate) {
                articleDictionary["image"] = NSNull()//nil
                article = CoreDataManager.update(object: articleDictionary, entityName: entityName, id: id) as! Article
                updatedIds.append(id)
                article.detail = nil
                print("item updated: \(id) - \(String(describing: articleDictionary[K.title]))")
            }
            else if !CoreDataManager.ifExist(entityName: entityName, id: id)    {
                article = CoreDataManager.insert(object: articleDictionary, entityName: entityName) as! Article
                insertIds.append(id)
                
                print("item inserted: \(id) - \(String(describing: articleDictionary[K.title]))")
            }
            else {
                article = CoreDataManager.fetchObject(entityName: entityName, id: id) as! Article
            }
            
            let isFavorite = articleDictionary["isFavorite"] as! Bool
            print("id=\(id), isFavorite=\(isFavorite))")
            if isFavorite {
                article.addToFavorite()
            }
            else {
                article.removeFromFavorite()
            }
            
            if type == K.recommended  {
                article.addToRecommended()
            }
            else if type == K.searchResults {
                article.addToSearchResults()
            }
        }
        
        // updating Articles against selected profile and if article have no any recommended profile, then remove from DB
        if K.recommended == type {
            
            let recommenedList = SessionManager.user!.recommendedArticles?.allObjects as! [Article]
            for recommendedArticle in recommenedList {
                
                if !newIds.contains(recommendedArticle.id) {
                    recommendedArticle.removeFromRecommended()
                    recommendedArticle.removeFromFavorite()
                    
                    if recommendedArticle.recommendedProfiles?.count == 0 {
                        CoreDataManager.deleteObject(object: recommendedArticle)
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
    static let imageUrl = "imageUrl"
    static let isFavorite = "isFavorite"
    static let lastUpdated = "lastUpdated"
    static let list = "list"
    static let searchResults = "searchResults"
    static let recommended = "recommended"
}
