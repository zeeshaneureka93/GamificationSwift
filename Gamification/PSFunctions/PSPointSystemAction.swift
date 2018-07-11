//
//  PSPointSystemAction.swift
//  Gamification
//
//  Created by Zeeshan on 7/10/18.
//  Copyright © 2018 Zeeshan. All rights reserved.
//

import UIKit

class PSPointSystemAction: NSObject {
    var secretKey = ""
    var userId = ""
    var userName = ""
    var email = ""
    var userAuthToken = ""
    var baseUrl = ""

    fileprivate static let sharedInstance = PSPointSystemAction()
    static var shared: PSPointSystemAction {
        get {
            return sharedInstance
        }
    }
    func setupConfiguration(gamificationkey:String,userId:String,userName:String,email:String,token:String,baseUrl:String) {
        self.secretKey = gamificationkey
        self.userId = userId
        self.userName = userName
        self.email = email
        self.userAuthToken = token
        self.baseUrl = baseUrl
        UserDefaults.standard.set(self.secretKey, forKey: "key")
        UserDefaults.standard.set(self.userId, forKey: "userId")
        UserDefaults.standard.set(self.userName, forKey: "username")
        UserDefaults.standard.set(self.email, forKey: "email")
        UserDefaults.standard.set(self.userAuthToken, forKey: "token")
        UserDefaults.standard.synchronize()
    }
}
