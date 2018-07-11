//
//  ReachabilityManager.swift
//  CoreDirection
//
//  Created by Yasir Ali on 4/11/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import Foundation
import Alamofire

class ReachabilityManager {
    private static let shared = ReachabilityManager()
    private var reachability: NetworkReachabilityManager!

    private init()  {
        reachability = NetworkReachabilityManager(host: "www.apple.com")
        if !reachability.isReachable    {
            NetworkToast.show()
        }
        
        reachability.listener = { status in
            Console.log(message: "Status = \(status)", sender: self)
            switch status {
            case .notReachable:
//                if !NSObject.checkForProxyConnectivity() && !NSObject.checkForVPNConnectivity() {
                    NetworkToast.show()
//                } else {
//                    NetworkToast.show(message: NSLocalizedString("Insecure_Internet_Connection", comment: ""))
//                }
                Console.log(error: "Network not reachable", sender: self)
                
            default:
                
//                if !NSObject.checkForProxyConnectivity() && !NSObject.checkForVPNConnectivity() {

                    NetworkToast.dismiss()
                    Console.log(message: "Network is now reachable!", sender: self)

//                    let currentController = UIApplication.topViewController()
//                    if let homeVC = currentController as? HomeViewController {
//                        homeVC.refreshContentIfRequiredOnInternetStatusUpdate()
//                    }
//                    else if let workoutVC = currentController as? WorkOutViewController {
//                        workoutVC.recommendedController.refreshContentIfRequiredOnInternetStatusUpdate()
//                    }
//                    else if let articleVC = currentController as? ArticleHomeViewController {
//                        articleVC.recommendedVC.refreshContentIfRequiredOnInternetStatusUpdate()
//                    }
                
//                }

            }
        }
    }
    
    
    class func isReachable() -> Bool    {
        if shared.reachability != nil  {
            return shared.reachability.isReachable
        }
        return false
    }
    
    class func startMonitoring()  {
        shared.reachability.startListening()
    }
    
    class func stopMonitoring() {
        shared.reachability.stopListening()
    }
}

