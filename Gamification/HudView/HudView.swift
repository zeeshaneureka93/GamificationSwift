//
//  HudView.swift
//  FashionWithFriends
//
//  Created by Muhammad Jabbar on 10/20/16.
//  Copyright © 2016 Envabe. All rights reserved.
//

import UIKit

class HudView: UIView {

    static let sharedInstance : HudView =  HudView.fromNib()

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndecatior: UIActivityIndicatorView!
    @IBOutlet weak var containerView: UIView!

    func startAnimation()  {
        self.imageView.rotateView(Key: "com.myapplication.rotationanimationkey")
    }
    func stopAnimation()  {
        activityIndecatior.stopAnimating()
    }
    class func showHudd() {
        DispatchQueue.main.async {

                for window in UIApplication.shared.windows.reversed() {
                    let windowOnMainScreen = window.screen == UIScreen.main
                    let windowIsVisible = !window.isHidden && window.alpha > 0
                    let windowLevelNormal = window.windowLevel == UIWindowLevelNormal
                    if windowOnMainScreen && windowIsVisible && windowLevelNormal {
                        let hud  = HudView.sharedInstance
                        hud.bounds = window.bounds
                        hud.frame = window.frame
                        window.addSubview(hud)
                        hud.startAnimation()
                        break
                    }
                }
            }
    }
   class func dismiss() {
   
    DispatchQueue.main.async {

    for window in UIApplication.shared.windows.reversed() {
        let windowOnMainScreen = window.screen == UIScreen.main
        let windowIsVisible = !window.isHidden && window.alpha > 0
        let windowLevelNormal = window.windowLevel == UIWindowLevelNormal
        
        if windowOnMainScreen && windowIsVisible && windowLevelNormal {
            
            if window.subviews.contains(HudView.sharedInstance)
            {
                let hud  = HudView.sharedInstance
                hud.stopAnimation()
                hud.removeFromSuperview()
                break
            }
            break
        }
    }
    }

    }
}
extension UIView {

    func rotateView(duration: Double = 1, Key: String ) {
        if self.layer.animation(forKey: Key) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float(Double.pi * 2.0)
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            self.layer.add(rotationAnimation, forKey: Key)
        }
    }
    func removeRotate(Key: String) {
        if (self.layer.animation(forKey: Key) != nil){
            self.layer.removeAnimation(forKey: Key)
        }
    }
    func rotate(radians: CGFloat, animated: Bool = false)
    {
        if animated
        {
            UIView.animate(withDuration: 0.2)
            {
                self.transform = CGAffineTransform(rotationAngle: radians)
            }
        }
        else
        {
            transform = CGAffineTransform(rotationAngle: radians)
        }
    }
    
}
