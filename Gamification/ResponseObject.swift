//
//  ReachabilityManager.swift
//  CoreDirection
//
//  Created by Yasir Ali on 4/11/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import Foundation

struct ResponseObject<T: ResponseObjectSerializable>: ResponseObjectSerializable, CustomStringConvertible {
    let meta: Meta
    var data: T?
    var error: String?
    
    var description: String {
        return "\nResponse {meta = \(meta), data = \(String(describing: data)), error = \(String(describing: error))}"
    }
    
    init?(response: HTTPURLResponse, representation: Any) {
        let representation = representation as? [String: Any]
        print("response: \(String(describing: representation)))")
        let meta = Meta(response: response, representation: representation?[Key.Response.meta] as Any)
        if let _data = representation?[Key.Response.data]    {
            let object = T(response: response, representation: _data)
                self.data = object
        }
        else  {
            self.error = representation?[Key.Response.error] as? String
        }
        
        self.meta = meta!
        
    }
}

