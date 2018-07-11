//
//  Action+AppProperties.swift
//  CoreDirection
//
//  Created by Ahmar on 9/5/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import Foundation
import CoreData

extension Action   {
  
    var isPerformedAction: Bool    {
        return self.performedUsers?.contains(SessionManager.user!) ?? false
    }
    
    func addToPerformedAction() {
        self.addToPerformedUsers(SessionManager.user!)
    }
    
    func removeFromPerformedAction() {
        self.removeFromPerformedUsers(SessionManager.user!)
    }
    
    class func fetchAllActions() -> [Action]{
        var actionsArray = [Action]()
        actionsArray = CoreDataManager.fetchList(entityName: Entity.action, predicate: nil) as! [Action]
        return actionsArray
    }

    class func isActionsEmpty() ->Bool {
        var actionsArray = [Action]()
        actionsArray = CoreDataManager.fetchList(entityName: Entity.action, predicate: nil) as! [Action]
        return actionsArray.isEmpty
    }

    class func bodyFatActionPointPerPercentage() -> Double {
        let fetchPredicate = NSPredicate(format: "name == %@", Key.ActionName.bodyFat)
        let action = CoreDataManager.fetchObject(entityName: Entity.action , predicate: fetchPredicate) as? Action
        return Double((action?.points)!)
    }
    

    class func fetchActionWith(acitonName: String, predicateString : String? = nil) -> Action? {
        var fetchPredicate = NSPredicate(format: "name == %@",acitonName)
        if let subPredicate = predicateString{
            fetchPredicate =  NSPredicate(format: "name == %@ && \(subPredicate)",acitonName)
        }
        return CoreDataManager.fetchObject(entityName: Entity.action , predicate: fetchPredicate) as? Action
    }
    
    class func sync(data: [String: Any], type: String = K.actionList, success:(() -> Void)? = nil)    {
        var actionList = data[K.actionList] as! [[String: Any]]
        print("=============================================")
        print("sync stared")
        let entityName = Entity.action
        
        var newIds = [Int64]()
        var updatedIds = [Int64]()
        var insertIds = [Int64]()
        
        for i in 0..<actionList.count {
            
            var actionDictionary = actionList[i]
            
            actionDictionary = GamificationParser.parseActionFor(dict: actionDictionary, type: type)
            
            let id = actionDictionary[K.id] as! Int64
            newIds.append(id)
            actionList[i] = actionDictionary
            
            var lastUpdated: Double = 0
            let lastUpdateValue = actionDictionary[K.lastUpdated]
            if  lastUpdateValue is Double   {
                lastUpdated = lastUpdateValue as! Double
            }
            else    {
                actionDictionary[K.lastUpdated] = lastUpdated
            }
            
            var action: Action!
            let updatePredicate = NSPredicate(format: "id == \(id) && lastUpdated != \(lastUpdated)")
            
            if CoreDataManager.ifExist(entityName: entityName, predicate: updatePredicate) {
                action = CoreDataManager.update(object: actionDictionary, entityName: entityName, id: id) as! Action
                updatedIds.append(id)
                print("item updated: \(id) - \(String(describing: actionDictionary[K.name]))")
            }
            else if !CoreDataManager.ifExist(entityName: entityName, id: id)    {
                action = CoreDataManager.insert(object: actionDictionary, entityName: entityName) as! Action
                insertIds.append(id)
                
                print("item inserted: \(id) - \(String(describing: actionDictionary[K.name]))")
            }
            else    {
                action = CoreDataManager.fetchObject(entityName: entityName, id: id) as! Action
                print("item fetched: \(String(describing: action.name))")
            }

            //action.addToPerformedAction()
        }
        
        print("=============================================")
        print("sync end")
        
        CoreDataStack.save()
        success?()
    }
    class func createLocalAction(data : [String:Any]) -> Action? {
       return CoreDataManager.insert(object: data, entityName: Entity.action) as? Action
    }
}


private struct K    {
    static let id = "id"
    static let title = "title"
    static let name = "name"
    static let imageUrl = "imageUrl"
    static let lastUpdated = "lastUpdated"
    static let actionList = "action"
}

