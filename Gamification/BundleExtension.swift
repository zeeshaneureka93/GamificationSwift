//
//  BundleExtension.swift
//  CoreDirection
//
//  Created by Ahmar on 12/25/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
