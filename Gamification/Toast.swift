//
//  Toast.swift
//  CoreDirection
//
//  Created by Yasir Ali on 8/9/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import Foundation

class Toast {

    var toastView: UIView!
    var isVisible = false
    let leftPadding = CGFloat(35)
    fileprivate static let shared = Toast()
    
    
    fileprivate class func makeToastView(message: String,controller: UIViewController? = nil, showInBottom : Bool = false, isSuccess: Bool,isHtml : Bool = false) -> UIView {
//
//        let controller = controller == nil ? UIManager.rootController() : controller!
//        let view = controller.view!
//        let toastWidth = view.frame.width
//        let textFont = UIFont.gothamLight(size: Fonts.Size.small)
//        var labelHeight = height(constraintedWidth: toastWidth, font: textFont, text: message)
//
//        let toastView = UIView()
//        let webView = UIWebView()
//        var frame = CGRect()
//        var toastLabel = InsetLabel()
//        let toastImage = UIImageView()
//
//        if isSuccess {
//            let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
//            let currentController = UIApplication.topViewController()
//            //let navigationBarHeight: CGFloat = (currentController?.navigationController?.navigationBar.isHidden)! ? 0 : (currentController?.navigationController?.navigationBar.frame.height)!
//            var navigationBarHeight: CGFloat = 0
//            if let navController = currentController?.navigationController {
//                if !navController.navigationBar.isHidden  {
//                    navigationBarHeight =  navController.navigationBar.frame.height + statusBarHeight
//                }
//            }
//            frame = CGRect(x: shared.leftPadding, y: 0, width: toastWidth - shared.leftPadding, height: labelHeight)
//
//            toastView.frame = CGRect(x: 0, y: navigationBarHeight, width: toastWidth, height: labelHeight)
//            toastView.backgroundColor = UIColor.appBlue
//            toastLabel = InsetLabel(frame: frame)
//            //webView.frame = isHtml ?  toastLabel.frame : .zero
//            if isHtml {
//                labelHeight = height(constraintedWidth: toastWidth, font: textFont, attributedText: self.stringFromHtml(string: message), forLines: 0)
//                frame = CGRect(x: shared.leftPadding, y: 0, width: toastWidth - shared.leftPadding, height: labelHeight)
//                toastView.frame = CGRect(x: 0, y: navigationBarHeight, width: toastWidth, height: labelHeight)
//                toastLabel.frame = frame
//                webView.frame = CGRect(x: toastLabel.frame.origin.x, y: toastLabel.frame.origin.y, width: toastLabel.frame.width, height: toastLabel.frame.height-8)
//            }
//            toastImage.image = #imageLiteral(resourceName: "toastTick")
//        }
//        else {
//            var tabBarHeight = CGFloat(0)
//            if controller is TabbarViewController { tabBarHeight = 49 }
//            if showInBottom { tabBarHeight = 0 }
//            frame = CGRect(x: shared.leftPadding, y: 0, width: toastWidth - shared.leftPadding, height: labelHeight)
//
//            toastView.frame = CGRect(x: 0, y: view.frame.height - (labelHeight + tabBarHeight), width: toastWidth, height: labelHeight)
//            toastView.backgroundColor = UIColor.appRed
//            toastLabel = InsetLabel(frame: frame)
//            webView.frame = isHtml ?  toastLabel.frame : .zero
//            toastImage.image = #imageLiteral(resourceName: "Toast-Information-icon")
//            toastImage.tintColor = .white
//        }
//
//        toastLabel.textColor = UIColor.white
//        toastLabel.font = textFont
//        toastLabel.text = message
//        toastLabel.alpha = 1.0
//        toastLabel.numberOfLines = 0
//        toastLabel.clipsToBounds  =  true
//        toastLabel.isHidden = false
//        toastView.addSubview(toastLabel)
//
//        if isHtml {
//            webView.backgroundColor = UIColor.clear
//            webView.isOpaque = false
//            toastView.addSubview(webView)
//            webView.loadHTMLString(message, baseURL: nil)
//            webView.isUserInteractionEnabled = false
//            toastLabel.isHidden = true
//        }
//
//        if UtilityManager.isLayoutDirectionRTL() {
//
//            toastImage.frame = CGRect(x: toastView.frame.size.width - 30, y: 0, width: 15, height: labelHeight)
//            toastLabel.textAlignment = .right
//            toastLabel.frame = CGRect(x: 0, y: toastLabel.frame.origin.y, width: toastLabel.frame.size.width, height: toastLabel.frame.size.height)
//            webView.frame = CGRect(x: 0, y: toastLabel.frame.origin.y, width: toastLabel.frame.size.width, height: toastLabel.frame.size.height)
//        }
//        else {
//            toastImage.frame = CGRect(x: 15, y: 0, width: 15, height: labelHeight)
//            toastLabel.textAlignment = .left
//        }
//        toastImage.contentMode = .scaleAspectFit
//        toastView.addSubview(toastImage)
//
//        view.addSubview(toastView)
//
//        return toastView
//    }
    
//    fileprivate class func stringFromHtml(string: String) -> NSAttributedString? {
//        do {
//                let attrStr = try? NSAttributedString.init(string: string, attributes: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType])
//                return attrStr
//        } catch (let exception) {
//            print(exception)
//        }
        return UIView()
    }

    fileprivate class func height(constraintedWidth width: CGFloat, font: UIFont, text: String? = nil, attributedText: NSAttributedString? = nil, forLines: Int = 0) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: shared.leftPadding, y: 0, width: width - shared.leftPadding, height: .greatestFiniteMagnitude))
        var margin: CGFloat = 20.0
        label.numberOfLines = forLines
        if text != nil {
            label.text = text
        }
        if attributedText != nil {
            label.attributedText = attributedText
            margin = 20
        }
        label.font = font
        label.sizeToFit()
        
        return label.frame.height + margin
    }
    
    class func show(message: String,controller: UIViewController? = nil, showInBottom : Bool = false , isSuccess : Bool = false, isHtml : Bool = false) {

        if shared.isVisible {
            return
        }
        shared.toastView = makeToastView(message: message,controller: controller,showInBottom : showInBottom, isSuccess: isSuccess, isHtml : isHtml)
        shared.isVisible = true

        UIView.animate(withDuration: 0.3, delay: 3.2, options: .curveEaseOut, animations: {
            shared.toastView.alpha = 0.0
        }, completion: {(isCompleted) in
            shared.toastView.removeFromSuperview()
            shared.isVisible = false
        })
    }
   
}
