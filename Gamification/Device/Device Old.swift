//
//  Device.swift
//  CoreDirection
//
//  Created by Administrator on 10/5/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import UIKit

class Device: UIDevice {
    static let model =  UIDevice.current.localizedModel
    static let osVersion =  UIDevice.current.systemVersion
    static let name =  UIDevice.current.name
    static let localizedModel =  UIDevice.current.localizedModel
    static let lang = Locale.current.languageCode
    static let osName = UIDevice.current.systemName
    //static let info = Device.model + Device.localizedModel + Device.osVersion
    static let info = ("\(Device.model) \(Device.name) \(Device.osName) \(Device.osVersion)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")!
}
