//
//  Console.swift
//  CoreDirection
//
//  Created by Yasir Ali on 8/8/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import UIKit

class Console {

    private init() {}
    class func log(error: String, sender: Any)    {
        print("\(String(describing: type(of: sender)))_Error: \(error)")
    }
    
    class func log(message: String, sender: Any)    {
        print("\(String(describing: type(of: sender)))_Message: \(message)")
    }
    
    class func log(info: String, sender: Any)   {
        print("\(String(describing: type(of: sender)))_Info: \(info)")
    }
}
