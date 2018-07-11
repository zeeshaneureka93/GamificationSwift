//
//  UIFontEx.swift
//  CoreDirection
//
//  Created by Muhammad Jabbar on 4/12/17.
//  Copyright © 2017 CoreDirection. All rights reserved.
//

import UIKit

extension UIFont {
    
    class func gothamBold(size: CGFloat = Fonts.Size.small) -> UIFont  {
        return UIFont(name: Fonts.Gotham.bold, size: size)!
    }

    class func gothamLight(size: CGFloat = Fonts.Size.normal) -> UIFont  {
        return UIFont(name: Fonts.Gotham.light, size: size)!
    }
    class func gothamMedium(size: CGFloat = Fonts.Size.small) -> UIFont  {
        return UIFont(name: Fonts.Gotham.medium, size: size)!
    }
    class func gothamMediumNormal(size: CGFloat = Fonts.Size.normal) -> UIFont  {
        return UIFont(name: Fonts.Gotham.medium, size: size)!
    }
    class func gotham_Bold(size: CGFloat = Fonts.Size.small) -> UIFont  {
        return UIFont(name: Fonts.Gotham.gBold, size: size)!
    }
    
    class func gothamMediumItalic(size: CGFloat = Fonts.Size.small) -> UIFont  {
        return UIFont(name: Fonts.Gotham.mediumItalic, size: size)!
    }
    class func gothamBook(size: CGFloat = Fonts.Size.small) -> UIFont  {
        return UIFont(name: Fonts.Gotham.gothamBook, size: size)!
    }
}
