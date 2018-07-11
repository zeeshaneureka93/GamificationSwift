//
//  PSAction.swift
//  Gamification
//
//  Created by Zeeshan on 7/11/18.
//  Copyright © 2018 Zeeshan. All rights reserved.
//

import Alamofire

class PSAction: NSObject {
    typealias successHandler = (Any?) -> Void
    typealias errorHandler = (NSError?) -> Void
    class func getActionsForCurrentUser(action method: String,
                                        parameters: Parameters,
                                        showProgress: Bool = false,
                                        onSuccess: @escaping JSONRequestManager.SuccessHandler,
                                        onFailure: @escaping JSONRequestManager.ErrorHandler) {
        JSONRequestManager.requestGamification(action: method,
                                               parameters: parameters,
                                               onSuccess: { (response: Any?) in
                                                onSuccess(response)
        }, onFailure: { (error: NSError?) in
//            print(error?.code as Any, error?.localizedDescription as Any)
            onFailure(error)
        })
    }
    class func addActionForCurrentUser(action method: String,parameters: Parameters,points: Int? = nil, timeStampString : String? = nil,showProgress: Bool = false,isLocal: Bool = true , success onSuccess : successHandler? = nil, error onError : errorHandler? = nil) {
        JSONRequestManager.requestGamification(action: method,
                                               parameters: parameters, onSuccess: { (response: Any?) in
                                                onSuccess?(response)
        }, onFailure: { (error: NSError?) in
//            print(error?.code as Any, error?.localizedDescription as Any)
            onError?(error)
        })
    }
    
}
