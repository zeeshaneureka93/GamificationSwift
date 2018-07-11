//
//  GamificationManager.swift
//  CoreDirection
//
//  Created by Adeel on 8/31/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import Alamofire
//import InAppNotify
class GamificationManager {
    fileprivate static let sharedInstance = GamificationManager()
    typealias successHandler = () -> Void
    typealias errorHandler = (NSError?) -> Void
    
    var badgeShouldSync = false
    var levelShouldSync = false
    var isActionCalling = false
    
    var numberOfCalls = 0
    var maxRetryCount = 3
    
    fileprivate init() {

    }
    static var shared : GamificationManager{
        get{
            return sharedInstance
        }
    }
    
    
    func resetAllLayouts() {
        self.badgeShouldSync = true
        self.levelShouldSync = true
    }
    

    class func getActionsForCurrentUser(action method: String,
                                        parameters: Parameters,
                                        showProgress: Bool = false,
                                        onSuccess: @escaping JSONRequestManager.SuccessHandler,
                                        onFailure: @escaping JSONRequestManager.ErrorHandler) {
        
        
        
        
        
        JSONRequestManager.requestGamification(action: method,
                                               parameters: parameters,
                                               onSuccess: onSuccess,
                                               onFailure: onFailure)
        
    }
    
    
    
    class func getBadgesForCurrentUser(action method: String,
                                       parameters: Parameters,
                                       showProgress: Bool = true,
                                       onSuccess: @escaping JSONRequestManager.SuccessHandler,
                                       onFailure: @escaping JSONRequestManager.ErrorHandler) {
        
        JSONRequestManager.requestGamification(action: method,
                                               parameters: parameters,
                                               showProgress: showProgress,
                                               onSuccess: onSuccess,
                                               onFailure: onFailure)
        
    }
    
    
    
    
    class func getLevelsForCurrentUser(action method: String,
                                       parameters: Parameters,
                                       showProgress: Bool = true,
                                       onSuccess: @escaping JSONRequestManager.SuccessHandler,
                                       onFailure: @escaping JSONRequestManager.ErrorHandler) {
        
        JSONRequestManager.requestGamification(action: method,
                                               parameters: parameters,
                                               showProgress: showProgress,
                                               onSuccess: onSuccess,
                                               onFailure: onFailure)
        
    }
    
    // Generic Method for Add actions for all gammification.
    
    class func addActionForCurrentUser(action: Action,points: Int? = nil, timeStampString : String? = nil,
                                       showProgress: Bool = false,isLocal: Bool = true , success onSuccess : successHandler? = nil, error onError : errorHandler? = nil) {
        
        var parameters : Parameters = [:]
        parameters["user_id"] = SessionManager.userId
        parameters["token"] = AppKeys.gamification
        if action.name == Key.ActionName.workoutConsistency{
            parameters["params"] = "{\"TIME_SPAN\" : \"\(timeStampString ?? "") \"}"
        }
        else if action.name == Key.ActionName.readArticle{
            parameters["params"] = "{\"BOOKWORM\" : \"\(timeStampString ?? "") \"}"
        }
        else if action.name == Key.ActionName.workoutCompleted{
            parameters["params"] = "{\"WORKOUT\" : \"\(timeStampString ?? "") \"}"
        }
        parameters[Key.Request.GamificationActions.id] = "\(action.id)"
        parameters[Key.Request.GamificationActions.type] = "\(action.type)"
        if let point = points {
            parameters[Key.Request.GamificationActions.pointsToOveride] = "\(point)"
        }
        parameters["lang"] = "\(Device.lang)"

        shared.isActionCalling = true
        
        JSONRequestManager.requestGamification(action: API.gamification.addActionDetail,
                                               parameters: parameters, onSuccess: { (response: Any?) in
                                                
                                                
                                                shared.isActionCalling = false
                                                print(response as Any)
                                                if let responseDictionary = response as? [String: Any]    {
                                                    if let infoDictionary = responseDictionary[Key.Response.info] as? [String: Any]{
                                                        
                                                        if let showAlert = infoDictionary[Key.Response.alert] as? Bool{
                                                            if showAlert  {
                                                                
                                                                if let message = infoDictionary[Key.Response.message] as? String {
                                                                    if message.lowercased().contains(NSLocalizedString("Gamification_badge", comment: "badge")) {
                                                                        GamificationManager.shared.badgeShouldSync = true
                                                                        
                                                                        var msgToShow = NSLocalizedString("Unlocked_Badge", comment: "")
                                                                        
                                                                        if var title =  infoDictionary[Key.Response.title] as? String {

                                                                            let wordToRemove = "\(NSLocalizedString(" Badge", comment: " Badge"))"
                                                                            title = title.capitalized
                                                                            if let range = title.range(of: wordToRemove) {
                                                                                title.removeSubrange(range)
                                                                            }
                                                                            msgToShow = "\(NSLocalizedString("You have just unlocked", comment: "")) \(title) \(NSLocalizedString("Gamification_badge", comment: "badge"))."
                                                                        }
                                                                        
                                                                        if isLocal{
                                                                            self.addLocalNotification(message: msgToShow)
                                                                        }else{
                                                                            //                                                                            AlertController.show(success: "You just unlocked a badge.")
//                                                                            UIManager.showCustomAlert(message: msgToShow,badgeImageURL: infoDictionary["img"] as? String ?? "")
                                                                        }
                                                                    }
                                                                    else {
                                                                        GamificationManager.shared.badgeShouldSync = true
                                                                        GamificationManager.shared.levelShouldSync = true
                                                                        if isLocal{
                                                                            self.addLocalNotification(message: NSLocalizedString("Completed_Level", comment: ""))
                                                                        }else{
//                                                                            UIManager.showCustomAlert(message: NSLocalizedString("Completed_Level", comment: ""))
                                                                        }
                                                                    }
                                                                }
                                                                
                                                            }else{
                                                                // Toast.show(message: message)
                                                                if isLocal {
//                                                                    self.addLocalNotification(message: "\(NSLocalizedString("You have just earned", comment: "")) \((points ?? Int(action.points)).localize()) \(NSLocalizedString("Gamification_points", comment: "points")).")
                                                                }
                                                                else {
//                                                                    UIManager.showCustomAlert(message: "\(NSLocalizedString("You have just earned", comment: "")) \((points ?? Int(action.points)).localize()) \(NSLocalizedString("Gamification_points", comment: "points")).", badgeImage:UIImage(named: "refresh_icon")!)
                                                                }
                                                            }
                                                            
                                                        }
                                                        onSuccess?()
                                                        
                                                    }
                                                }
        }, onFailure: { (error: NSError?) in
            print(error?.code as Any, error?.localizedDescription as Any)
            shared.isActionCalling = false
            onError?(error)

        })
        
    }
    
    
    class func addLocalNotification(message:String){
        
        let announce = Announcement(
            //Title, the first line
            title           : message,
            image           : UIImage(named: "refresh_icon"),
            //Seconds before disappear
            duration        : 5,
            //Interaction type. none or text
            interactionType : InteractionType.none,
            //Action callback
            action: { (type, string, announcement) in
                
                //You can detect the action by test "type" var
                if type == CallbackType.tap{
                    print("User has been tapped")
                }else if type == CallbackType.text{
                    print("Reply from notification: \(string!)")
                }else{
                    print("Notification has been closed!")
                }
        }
        )
//        InAppNotify.Show(announce, to: UIManager.rootController())
    }
    
    class func getActionIfNeeded() {
        if Action.fetchAllActions().isEmpty {
            GamificationManager.getAction()
        }
    }
    
    class func getAction() {
        
        // fetch action information for current User
        var parameters = [String: Any]()
        if let sessionInfo = SessionManager.getInfo() {
            parameters["user_id"] = "\(sessionInfo.userId)"
        }
        parameters["token"] = AppKeys.gamification
        parameters["lang"] = "\(Device.lang)"

        GamificationManager.getActionsForCurrentUser(action: API.gamification.getAction, parameters: parameters, onSuccess: { actionResponse in
            
            let data = actionResponse as! [String: Any]
            print("action response: \n\(data)")
            Action.sync(data: data, success : {
                syncLocalActions()
                shared.numberOfCalls = 0
            })
            
        }, onFailure: { error in
            // no need for toast we are handling in request managers
            print(error as Any)
            if error?.code == ResponseCode.noInternetError, shared.numberOfCalls < shared.maxRetryCount{
                shared.numberOfCalls += 1
                print(shared.numberOfCalls)
                GamificationManager.getAction()
            }
        })
        
    }
    class func syncLocalActions() {
        if shared.isActionCalling {
            print("GamificationManager.sharedInstance.isActionCalling")
            return
        }
        
        if let userAction = SessionManager.user?.pendingActions?.firstObject as? PendingActions {
            if let action = Action.fetchActionWith(acitonName: userAction.name ?? "") {
                GamificationManager.addActionForCurrentUser(action: action, points: (userAction.name == Key.ActionName.workoutCompleted || userAction.name == Key.ActionName.bodyFat) ? Int(userAction.points * action.points) : nil, timeStampString: action.name == Key.ActionName.workoutConsistency ? userAction.utcTimeStampStr : nil , success: {
                    userAction.removeFromPendingAction()
                    CoreDataStack.save()
                    print("=========------")
                    syncLocalActions()
                }, error: { error in
                    
                    if error?.code == ResponseCode.gamificationError || error?.code == ResponseCode.gamificationParserError {
                        userAction.removeFromPendingAction()
                        syncLocalActions()
                    }
                })
            }
        }
    }
    
    class func addAction(name:String,points:Int? = nil, showHud : Bool = false, success onSuccess : successHandler? = nil, error onError : (() -> Void)? = nil) {
        
        if let action = Action.fetchActionWith(acitonName:name) {
            
            if let points = points , name == Key.ActionName.workoutCompleted {
                GamificationManager.addActionForCurrentUser(action: action, points: points * Int(action.points), showProgress: showHud, isLocal: false ,success: {
                    onSuccess?()
                }, error: { error in
                    
                    if error?.code != ResponseCode.gamificationError , error?.code != ResponseCode.gamificationParserError {
                        let actionDictionary : [String:Any] = ["name" : name,"points":points]
                        if let action =  PendingActions.createLocalAction(data: actionDictionary){
                            action.addToPendingAction()
                            GamificationManager.syncLocalActions()
                        }
                        
                    }else {
                        GamificationManager.syncLocalActions()
                    }
                    onError?()

                })
                return
            }
            GamificationManager.addActionForCurrentUser(action: action, isLocal: false, success: {
                onSuccess?()
            }, error: { error in

                if error?.code != ResponseCode.gamificationError , error?.code != ResponseCode.gamificationParserError {
                    let actionDictionary : [String:Any] = ["name" : name]
                    if let action =  PendingActions.createLocalAction(data: actionDictionary){
                        action.addToPendingAction()
                        if  error?.code == ResponseCode.noInternetError {
                            onError?()
                            return
                        }
                        GamificationManager.syncLocalActions()
                    }

                }else {
                    GamificationManager.syncLocalActions()
                }
                onError?()

            })
        }else{
            
            var actionDictionary : [String:Any] = ["name" : name]
            if let pointsValue = points {
                actionDictionary["points"] = pointsValue
            }
            if let action =  PendingActions.createLocalAction(data: actionDictionary){
                action.addToPendingAction()
            }
            //            let _ = GamificationManager.shared
            GamificationManager.getAction()
            onError?()

        }
    }
    class func addLocalAction(actionDictionary:[String:Any]){
        
        if let action =  PendingActions.createLocalAction(data: actionDictionary){
            action.addToPendingAction()
        }
    }
    class func addConsistansyLocalAction(){
        let formate = DateFormatter()
        formate.dateFormat = "yyyy-MM-dd"
        formate.timeZone = TimeZone(abbreviation: "UTC")
        let actionDictionary : [String:Any] = ["name" : Key.ActionName.workoutConsistency, "utcTimeStampStr":formate.string(from: Date())]
        GamificationManager.addLocalAction(actionDictionary:actionDictionary)
        GamificationManager.syncLocalActions()
    }
    class func getBadges( onSuccess: @escaping JSONRequestManager.SuccessHandler, onFailure: @escaping JSONRequestManager.ErrorHandler) {
        
        // fetch badges information for current User
        var parameters = [String: Any]()
        parameters = ["user_id": "\(SessionManager.userId)", "token": AppKeys.gamification, "lang": Device.lang]

        GamificationManager.getBadgesForCurrentUser(action: API.gamification.getBadgesInfo, parameters: parameters, onSuccess: { badgeResponse in
            let data = badgeResponse as! [String: Any]
            print("badge response: \n\(data)")
            Badge.sync(data: data)
            onSuccess(data)
        }, onFailure: { error in
            // no need for toast we are handling in request managers
            onFailure(error)
        })
        
    }
    
    class func getLevels( onSuccess: @escaping JSONRequestManager.SuccessHandler, onFailure: @escaping JSONRequestManager.ErrorHandler) {
        
        // fetch levels information for current User
        var parameters = [String: Any]()
        //parameters = ["user_id": "\(994)", "token": AppKeys.gamification, "lang": "en"]
        parameters = ["user_id": "\(SessionManager.userId)", "token": AppKeys.gamification, "lang": Device.lang]
        
        GamificationManager.getLevelsForCurrentUser(action: API.gamification.getLevelsInfo, parameters: parameters, onSuccess: { levelsResponse in
            let data = levelsResponse as! [String: Any]
            print("level response: \n\(data)")
            Level.sync(data: data)
            onSuccess(data)
        }, onFailure: { error in
            // no need for toast we are handling in request managers
            onFailure(error)
            
        })
        
    }
    
    
}


