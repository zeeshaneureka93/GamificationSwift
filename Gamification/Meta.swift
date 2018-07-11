//
//  ReachabilityManager.swift
//  CoreDirection
//
//  Created by Yasir Ali on 4/11/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//


import Alamofire

struct Meta: ResponseObjectSerializable, CustomStringConvertible {
    let code: Int
    let status: String
    
    var description: String    {
        return "\nMeta { code = \(code), status = \(status)}"
    }
    
    init?(response: HTTPURLResponse, representation: Any) {
        guard
            let representation = representation as? [String: Any],
            let _code = representation[Key.Response.code] as? Int,
            let _status = representation[Key.Response.status] as? String
        else {
            return nil
        }
        
        self.code = _code
        self.status = _status
    }
}

