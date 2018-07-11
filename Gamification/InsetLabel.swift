//
//  InsetLabel.swift
//  CoreDirection
//
//  Created by Yasir Ali on 8/9/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import Foundation

class InsetLabel: UILabel   {
    let insets = UIEdgeInsetsMake(0, 10, 0, 10)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override public var intrinsicContentSize: CGSize   {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += insets.top + insets.bottom
        intrinsicSuperViewContentSize.width += insets.left + insets.right
        return intrinsicSuperViewContentSize
    }
}
