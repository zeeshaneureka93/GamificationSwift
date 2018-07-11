//
//  SessionManager.swift
//  ZonTrack
//
//  Created by Muhammad Jabbar on 04/14/17.
//  Copyright © 2016 Vio Apps. All rights reserved.
//

import Foundation

class SessionManager: NSObject {

    typealias CompletionHandler = () -> Void

    private(set) var info: SessionInfo?
    private static let sharedInstance = SessionManager()
    
    private override init() {
        info = nil
    }
    private func set(sessionInfo: SessionInfo?)   {
        self.info = sessionInfo
    }
    class func getInstance() -> SessionManager  {
        return sharedInstance
    }
    
    class func save(sessionInfo: [String: Any], onComplete: @escaping CompletionHandler) {

        var info: SessionInfo!
        var sessionInfoDictionary = sessionInfo
        let userDictionary = sessionInfoDictionary["user"] as! [String: Any]
        let id = userDictionary["id"] as! Int64
        
        CoreDataManager.deleteAll(entityName: Entity.sessionInfo)
        
        var user: AppUser!
        
        
        if CoreDataManager.ifExist(entityName: Entity.user, id: id)    {
            
            user = CoreDataManager.update(object: userDictionary, entityName: Entity.user, id: id) as! AppUser
        }
        else    {
            user = CoreDataManager.insert(object: userDictionary, entityName: Entity.user) as! AppUser
        }
        
        sessionInfoDictionary.removeValue(forKey: "user")
        info = CoreDataManager.insert(object: sessionInfo, entityName: Entity.sessionInfo) as! SessionInfo
        info.user = user
        
        CoreDataStack.save()
        sharedInstance.set(sessionInfo: info)
        onComplete()
        
    }
    
    class func save(user: User)    {
        SessionManager.user?.firstName = user.firstName
        SessionManager.user?.lastName = user.lastName
        SessionManager.user?.gender = user.gender.rawValue
        SessionManager.user?.dateOfBirth = user.dateOfBirth
        SessionManager.user?.joiningDate = user.joiningDate
        SessionManager.user?.imageUrl = user.imageUrl
        SessionManager.user?.phone = user.phone
        CoreDataStack.save()
    }
    
    class func removeSession() {
        sharedInstance.set(sessionInfo: nil)
        CoreDataManager.deleteAll(entityName: Entity.sessionInfo)
        CoreDataStack.save()
    }
    
    class func resume() -> SessionInfo? {
        
        let sessionInfo = CoreDataManager.fetchObject(entityName: Entity.sessionInfo) as? SessionInfo
        sharedInstance.set(sessionInfo: sessionInfo)
        return sessionInfo
    }

    class func isLoggedIn() -> Bool {
        return sharedInstance.info != nil
    }
    
    class func isEmptyOrResume() -> Bool {
        if  let sessionInfo = self.resume() {
            if sessionInfo.keepLogin {
                return false
            }else{
                self.removeSession()
            }
        }
        return true
    }
    
    class func getInfo() -> (userId: Int, sessionToken: String)? {
        if let info = sharedInstance.info {
            return (Int(truncatingIfNeeded: (info.user?.id)!), info.authToken!)
        }
        return nil
    }
    
    class var userId: Int {
        return getInfo()?.userId ?? 0
    }
    
    class var user: AppUser?   {
        return SessionManager.sharedInstance.info?.user
    }
    
    class func logout()    {
        if isLoggedIn() {
            removeSession()
//            UIManager.showLoginScreen()
        }
        
    }
    class func getSessionInfo() -> SessionInfo?  {
        return sharedInstance.info
    }
}
