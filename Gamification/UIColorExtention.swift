//
//  AlamahColors.swift
//  Alamh
//
//  Created by Muhammad Jabbar on 11/7/16.
//  Copyright © 2016 Lucky Brothers. All rights reserved.
//

import UIKit

extension UIColor   {

    public class var appBlue: UIColor  {
        return UIColor(hex: 0x47B5F9, alpha: 1.0)
    }
    
    public class var appRed: UIColor  {
        return appRed()
    }
    
    class func appRed(alpha: CGFloat = 1) -> UIColor   {
        return UIColor(hex: 0xFF7C6C, alpha: alpha)
    }
    class func appCardDark(alpha: CGFloat = 1) -> UIColor   {
        return UIColor(hex: 0x8d8d8d, alpha: alpha)
    }
    public class var appGreen: UIColor  {
        return appGreen()
    }
    public class var apphadow: UIColor  {
        return UIColor(hex: 0xebebeb, alpha: 1)
    }
    class func appGreen(alpha: CGFloat = 1) -> UIColor   {
        return UIColor(hex: 0xBED62F, alpha: alpha)
    }
    
    class func appButtonDisabled(alpha: CGFloat = 1.0) -> UIColor   {
        return UIColor(hex: 0xB2B2B2, alpha: alpha)
    }

    class func appLightGreen(alpha: CGFloat = 1) -> UIColor   {
        return UIColor(hex: 0xF2F7D5, alpha: alpha)
    }
    
    class func appOrange(alpha: CGFloat = 1) -> UIColor   {
        return UIColor(hex: 0xFF9758, alpha: alpha)
    }
    class func cancleStatus(alpha: CGFloat = 1) -> UIColor   {
        return UIColor(hex: 0xe8503e, alpha: alpha)
    }
    class func expireStatus(alpha: CGFloat = 1) -> UIColor   {
        return UIColor(hex: 0x545454, alpha: alpha)
    }
    public class var appLightGray: UIColor  {
        return appLightGray()
    }
    
    public class func appLightGray(alpha: CGFloat = 1) -> UIColor  {
        return UIColor(red: 0.902, green: 0.906, blue: 0.91, alpha: alpha)
    }
    
    public class var appDarkGray: UIColor  {
        return appDarkGray()
    }
    
    public class var appCorePass: UIColor  {
        return UIColor(red: 242/255.0, green: 247/255.0, blue: 213/255.0, alpha: 1.0)
    }
    public class var dateUnSelected: UIColor  {
        return UIColor(hex: 0x939597, alpha: 1.0)
    }
    public class var dateOutOfMonth: UIColor  {
        return UIColor(hex: 0xcccccc, alpha: 1.0)
    }
    public class var dateWithinMonth: UIColor  {
        return UIColor(hex: 0x333a49, alpha: 1.0)
    }
    public class var expireSlot: UIColor  {
        return UIColor(hex: 0x333333, alpha: 1.0)
    }
    public class func appDarkGray(alpha: CGFloat = 1) -> UIColor  {
        return UIColor(red: 0.341, green: 0.345, blue: 0.357, alpha: alpha)
    }
    class func appLightGraySeperator(alpha: CGFloat = 1) -> UIColor   {
        return UIColor(hex: 0x73706E, alpha: alpha)
    }
    class func forgetEmailTextFieldPlaceholderColor(alpha: CGFloat = 1) -> UIColor   {
        return UIColor(hex: 0xADADAD, alpha: alpha)
    }
    class func slotAvailableBackground(alpha: CGFloat = 1) -> UIColor   {
        return UIColor(hex: 0xb6cd2b, alpha: alpha)
    }
    class func slotAvailableRightViewBackground(alpha: CGFloat = 1) -> UIColor   {
        return UIColor(hex: 0xff9758, alpha: alpha)
    }
    class func slotExpireBackground(alpha: CGFloat = 1) -> UIColor   {
        return UIColor(hex: 0xa1a1a1, alpha: alpha)
    }
    class func slotExpireRightViewBackground(alpha: CGFloat = 1) -> UIColor   {
        return UIColor(hex: 0x868686, alpha: alpha)
    }
    class func bookLightGrayColor(alpha: CGFloat = 1) -> UIColor   {
        return UIColor(hex: 0xa1a1a1, alpha: alpha)
    }
    class func calanderLineColor(alpha: CGFloat = 1) -> UIColor   {
        return UIColor(hex: 0xbec3cf, alpha: alpha)
    }
    class func freePassFlagGreenBackgroundColor(alpha: CGFloat = 1) -> UIColor   {
        return UIColor(hex: 0x738600, alpha: alpha)
    }
    
    convenience init(hex: Int, alpha: CGFloat) {
        let r = CGFloat((hex & 0xFF0000) >> 16)/255
        let g = CGFloat((hex & 0xFF00) >> 8)/255
        let b = CGFloat(hex & 0xFF)/255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    convenience init(hex: Int) {
        self.init(hex:hex, alpha:1.0)
    }
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
