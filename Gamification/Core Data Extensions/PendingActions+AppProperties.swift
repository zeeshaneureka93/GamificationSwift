//
//  PendingActions+AppProperties.swift
//  CoreDirection
//
//  Created by Ahmar on 9/18/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import UIKit
import CoreData

extension PendingActions   {
    
    func addToPendingAction() {
        self.addToPendingUsers(SessionManager.user!)
        CoreDataStack.save()
    }
    
    func removeFromPendingAction() {
        self.removeFromPendingUsers(SessionManager.user!)
        self.deletePendingAction()
    }
    func deletePendingAction() {
        CoreDataManager.deleteObject(object: self)
    }
    
    class func fetchAllActions() -> [PendingActions] {
        
        return [PendingActions]()
    }
    
    class func isActionsEmpty() ->Bool {
        var actionsArray = [PendingActions]()
        actionsArray = CoreDataManager.fetchList(entityName: Entity.pendingActions, predicate: nil) as! [PendingActions]
        return actionsArray.isEmpty
    }
    
    class func fetchActionWith(acitonName: String) -> PendingActions? {
        let fetchPredicate = NSPredicate(format: "name == %@",acitonName)
        return CoreDataManager.fetchObject(entityName: Entity.pendingActions , predicate: fetchPredicate) as? PendingActions
    }
    
    class func createLocalAction(data : [String:Any]) -> PendingActions? {
        return CoreDataManager.insert(object: data, entityName: Entity.pendingActions) as? PendingActions
    }
}


private struct K    {
    static let id = "id"
    static let title = "title"
    static let imageUrl = "imageUrl"
    static let lastUpdated = "lastUpdated"
    static let actionList = "action"
}
