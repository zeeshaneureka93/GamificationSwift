//
//  NetworkToast.swift
//  CoreDirection
//
//  Created by Yasir Ali on 8/10/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import Foundation

class NetworkToast {
    var toastLabel: InsetLabel!
    var isVisible = false
    
    fileprivate static let shared = NetworkToast()
    
    class func dismiss() {
        if !shared.isVisible    {
            return
        }
        UIView.animate(withDuration: 0.3, delay: 1, options: .curveEaseOut, animations: {
            shared.toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            shared.toastLabel.removeFromSuperview()
            shared.isVisible = false
        })
    }
    
    class func show(message: String = NSLocalizedString("No_Internet_Connection", comment: ""))    {
        if shared.isVisible {
            return
        }
        shared.isVisible = true
    }
    
    class func bringToFront()   {
        if shared.isVisible {
            shared.toastLabel.removeFromSuperview()
            shared.isVisible = false
            show()
        }
    }
}
