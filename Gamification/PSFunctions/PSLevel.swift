//
//  PSLevel.swift
//  Gamification
//
//  Created by Zeeshan on 7/11/18.
//  Copyright © 2018 Zeeshan. All rights reserved.
//

import Alamofire
class PSLevel: NSObject {
    class func getLevelsForCurrentUser(action method: String,
                                       parameters: Parameters,
                                       showProgress: Bool = true,
                                       onSuccess: @escaping JSONRequestManager.SuccessHandler,
                                       onFailure: @escaping JSONRequestManager.ErrorHandler) {
        JSONRequestManager.requestGamification(action: method,
                                               parameters: parameters,
                                               showProgress: showProgress,
                                               onSuccess: { (response: Any?) in
                                                onSuccess(response)
        }, onFailure: { (error: NSError?) in
            //            print(error?.code as Any, error?.localizedDescription as Any)
            onFailure(error)
        })
    }
    
}
