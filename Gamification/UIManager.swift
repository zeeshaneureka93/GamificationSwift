//
//  UIManager.swift
//  CoreDirection
//
//  Created by Ahmar on 10/16/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import UIKit
//import IQKeyboardManagerSwift
//import GoogleMaps

class UIManager {
    
    static let buttonInvoiceWidth = 50.0
    static let cartView : CartView = CartView.fromNib()
    static let customAlertView : CustomAlertView = CustomAlertView.fromNib()
    static var actionButton: ActionButton!


    class func configureKeyboardAndNavBarAppearence() {
        let keyboardManager = IQKeyboardManager.sharedManager()
        keyboardManager.enable = true
        keyboardManager.shouldResignOnTouchOutside = true
        keyboardManager.enableAutoToolbar = false
        Appearance.apply()
    }
    
    class func configureSupportedLanguages() {
        let currentLangCode = Locale.current.languageCode
        let listLanguages = listOfSupportedLanguages
        if listLanguages.contains(currentLangCode!) {
            UserDefaults.standard.set([currentLangCode], forKey: "AppleLanguages")
        }
        else {
            UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
        }
        UserDefaults.standard.synchronize()
    }
    
    class func configureUserDefinedLanguage() {
        let currentLangCode = lastUserSelectedLanguageCode
        let listLanguages = listOfSupportedLanguages
        if listLanguages.contains(currentLangCode) {
            UserDefaults.standard.set([currentLangCode], forKey: "AppleLanguages")
        }
        else {
            UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
        }
        UserDefaults.standard.synchronize()
    }
    

    class func rootController() -> UIViewController {
        Console.log(info: String(describing: (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController), sender: self)
        return (AppDelegate.shared().window?.rootViewController!)!        
    }

    class func showLoginScreen() {
        let storyboard = UIStoryboard(name:Storyboard.authentication, bundle:nil)
        let loginConroller = storyboard.instantiateViewController(withIdentifier: "LoginNavigation")
        AppDelegate.shared().window?.rootViewController = loginConroller
        AppDelegate.shared().window?.makeKeyAndVisible()
        Console.log(info: String(describing: AppDelegate.shared().window?.rootViewController), sender: self)
        if !ReachabilityManager.isReachable() {
            NetworkToast.bringToFront()
        }
    }
    
    class func showHomeScreen(){
        let storyboard = UIStoryboard(name:Storyboard.tabbar, bundle:nil)
        let loginConroller = storyboard.instantiateViewController(withIdentifier: "TabbarViewController")
        AppDelegate.shared().window?.rootViewController = loginConroller
        AppDelegate.shared().window?.makeKeyAndVisible()
        setupInvoiceButton()
        setupActionButton()
    }
    class func showUpdatedHomeScreen(){
        if let tabbar = AppDelegate.shared().window?.rootViewController as? TabbarViewController {
            let nav = tabbar.selectedViewController as! NavigationViewController
            nav.popToRootViewController(animated: false)
        }
//        let storyboard = UIStoryboard(name:Storyboard.tabbar, bundle:nil)
//        let loginConroller = storyboard.instantiateViewController(withIdentifier: "TabbarViewController")
//        AppDelegate.shared().window?.rootViewController = loginConroller
//        AppDelegate.shared().window?.makeKeyAndVisible()
//        setupInvoiceButton()
//        setupActionButton()
    }
    
    
    class func showUpdatedActivityHomeScreen(alertMessage: String = "") {
        if let tabbar = AppDelegate.shared().window?.rootViewController as? TabbarViewController {
            // Make compulsory refreshing of Activity Recommended screen
            tabbar.selectedIndex = 1
            let nav = tabbar.selectedViewController as! NavigationViewController
            nav.popToRootViewController(animated: false)
            let activityHomeVC = nav.viewControllers.first as! ActivityHomeViewController
            activityHomeVC.fetchRecommendedData()
            if alertMessage != "" {
                let popTime = DispatchTime.now() + 0.05
                DispatchQueue.main.asyncAfter(deadline: popTime) {
                    Toast.show(message: alertMessage)
                }
            }
        }
    }
    
    class func showUpdatedWalletScreen(isSessionTabSelected: Bool = false, isMemebershipTabSelected: Bool = false) {
        if let tabbar = AppDelegate.shared().window?.rootViewController as? TabbarViewController {
            // Make compulsory refreshing of Activity Recommended screen
            tabbar.selectedIndex = 1
            var nav = tabbar.selectedViewController as! NavigationViewController
            let controllers = nav.viewControllers
            print(controllers)
            nav.popToRootViewController(animated: false)
            let activityHomeVC = nav.viewControllers.first as! ActivityHomeViewController
            activityHomeVC.fetchRecommendedData()
            
            var tabSelectionInvoicePreferenceForWallet = false
            var tabSelectionIndexForWallet = 0
            // Show updated Wallet Screen
            if InvoiceManager.sharedInstance.packageTypeForWallet !=  nil {
                if InvoiceManager.sharedInstance.packageTypeForWallet == "Session" {
                    tabSelectionInvoicePreferenceForWallet = true
                    tabSelectionIndexForWallet = 0
                    InvoiceManager.sharedInstance.packageTypeForWallet = nil
                } else if InvoiceManager.sharedInstance.packageTypeForWallet == "Membership" {
                    tabSelectionInvoicePreferenceForWallet = true
                    tabSelectionIndexForWallet = 1
                    InvoiceManager.sharedInstance.packageTypeForWallet = nil
                }
            }
            else if InvoiceManager.sharedInstance.slotDateForWallet != nil {
                tabSelectionInvoicePreferenceForWallet = true
                tabSelectionIndexForWallet = 2
            }
            tabbar.selectedIndex = 4
            nav = tabbar.selectedViewController as! NavigationViewController
            let walletVC = nav.viewControllers.first as! WalletViewController
            
            let popTime = DispatchTime.now() + 0.05
            DispatchQueue.main.asyncAfter(deadline: popTime) {
                if UtilityManager.isLayoutDirectionRTL() {
                    walletVC.setSelectedInex(index: tabSelectionInvoicePreferenceForWallet ? tabSelectionIndexForWallet:  ( isSessionTabSelected ? 2 :  0 ) )
                }
                else {
                    walletVC.setSelectedInex(index: tabSelectionInvoicePreferenceForWallet ? tabSelectionIndexForWallet:  ( isSessionTabSelected ? 0 :  2 ) )
                }
                walletVC.fetchData()
            }
        }
    }
    
    class func showUpdatedProfileScreen() {
        if let tabbar = AppDelegate.shared().window?.rootViewController as? TabbarViewController {
            tabbar.selectedIndex = 0
            let nav = tabbar.selectedViewController as! NavigationViewController
            nav.popToRootViewController(animated: false)
            let homeVC = nav.viewControllers.first as! HomeViewController
            homeVC.profileButtonTapped()
        }
    }

    class func showUpdatedActivityScreen() {
        if let tabbar = AppDelegate.shared().window?.rootViewController as? TabbarViewController {
            // Make compulsory refreshing of Activity Recommended screen
            for vc in tabbar.viewControllers ??  [] {
                if let nVC = vc as? NavigationViewController {
                    if let activityHomeVC = nVC.viewControllers.first as? ActivityHomeViewController {
                        if let index = tabbar.viewControllers?.index(of: nVC) {
                            tabbar.selectedIndex = index
                        }
                        nVC.popToRootViewController(animated: false)
                        activityHomeVC.fetchRecommendedData()
                        break
                    }
                }
            }
        }
    }

    class func openSettings() {
        let urlString = UIApplicationOpenSettingsURLString
        self.openURL(with: urlString)
    }
    class func openURL(with urlString: String) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: urlString)!)
        } else {
            UIApplication.shared.openURL(URL(string: urlString)!)
        }
    }
    class func checkAndOpenURL(with urlString: String, completionHandler completion: ((Bool) -> Swift.Void)? = nil) {
        var hasOpenedURL = false
        if(UIApplication.shared.canOpenURL(URL(string: urlString)!)) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: completion)
            } else {
                hasOpenedURL = UIApplication.shared.openURL(URL(string: urlString)!)
                completion?(hasOpenedURL)
            }
        } else {
            completion?(false)
        }
    }
    class func callToNumber(number:String) {
        let phoneFallback = "telprompt://\(number)"
        let phone = "tel://\(number)"
        UIManager.checkAndOpenURL(with: phoneFallback, completionHandler: { hasOpenedURL in
            if !hasOpenedURL {
                UIManager.checkAndOpenURL(with: phone, completionHandler: { hasOpenedURL in
                    if !hasOpenedURL {
                        print("unable to open url for call")
                    }
                })
            }
        })
    }

    class func showArticleScreen() {
        if let tabbar = AppDelegate.shared().window?.rootViewController as? TabbarViewController {
            for vc in tabbar.viewControllers ??  [] {
                if let nVC = vc as? NavigationViewController {
                    if let _ = nVC.viewControllers.first as? ArticleHomeViewController {
                        if let index = tabbar.viewControllers?.index(of: nVC) {
                            tabbar.selectedIndex = index
                        }
                        nVC.popToRootViewController(animated: false)
                        break
                    }
                }
            }
        }
    }
    
    class func showWorkoutScreen() {
        if let tabbar = AppDelegate.shared().window?.rootViewController as? TabbarViewController {
            for vc in tabbar.viewControllers ??  [] {
                if let nVC = vc as? NavigationViewController {
                    if let _ = nVC.viewControllers.first as? WorkOutViewController {
                        if let index = tabbar.viewControllers?.index(of: nVC) {
                            tabbar.selectedIndex = index
                        }
                        nVC.popToRootViewController(animated: false)
                        break
                    }
                }
            }
        }
    }

    
    // MARK: Cart
    
    class func setupInvoiceButton() {
        if let view = AppDelegate.shared().window?.rootViewController?.view {
            cartView.setup(attachedToView: view)
        }
        hideInvoiceButton()
    }
    
    class func showInvoiceButton() {
        cartView.isHidden = false
        cartView.alpha = 1.0
        cartView.isUserInteractionEnabled = true
        cartView.countLabel.text = InvoiceManager.cartItemCount()
    }
    
    class func hideInvoiceButton() {
        cartView.isHidden = true
        cartView.alpha = 0.0
        cartView.isUserInteractionEnabled = false
    }
    
    // MARK: Action Button
    
    class func setupActionButton() {
        // Cart Setup
        let cart = ActionButtonItem(title: NSLocalizedString("Cart", comment: ""), image: #imageLiteral(resourceName: "cart"), isCartEnable: true)
        cart.cartLabel.text = InvoiceManager.cartItemCount()
        cart.logoImageView.tintColor = UIColor.appCardDark()
        cart.action = { item in
            self.actionButton.toggleMenu()
            if !InvoiceManager.isCartEmpty() {
                // show Cart Screen
                let activityStoryboard = UIStoryboard(name: Storyboard.activity, bundle: Bundle.main)
                let navVC = activityStoryboard.instantiateViewController(withIdentifier: "InvoiceNavigationController") as! UINavigationController
                AppDelegate.shared().window?.rootViewController?.present(navVC, animated: true, completion: nil)
            }
            else {
                Toast.show(message: NSLocalizedString("Cart_Empty", comment: ""))
            }
        }
        
        // History Setup
        let history = ActionButtonItem(title: NSLocalizedString("History", comment: ""), image: #imageLiteral(resourceName: "History"))
        history.logoImageView.tintColor = UIColor.init(hex: 0x8d8d8d)
        history.action = { item in
            var viewControllerIdentifier = ""
            if let tabbar = AppDelegate.shared().window?.rootViewController as? TabbarViewController {
                let nav = tabbar.selectedViewController as! NavigationViewController
                let walletVC = nav.viewControllers.first as! WalletViewController
                var controllersArray =  ["BookedSessionHistoryNavigationController","WalletMembershipHistoryNavigationController"]
                if UtilityManager.isLayoutDirectionRTL(){
                    controllersArray = controllersArray.reversed()
                }
                viewControllerIdentifier = controllersArray[walletVC.segmentControl.selectedIndex]
            }
            self.actionButton.toggleMenu()
            let activityStoryboard = UIStoryboard(name: Storyboard.wallet, bundle: Bundle.main)
            let navVC = activityStoryboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as! UINavigationController
            AppDelegate.shared().window?.rootViewController?.present(navVC, animated: true, completion: nil)
        }
        
        
        // Memebership Number Setup
        let membershipNumber = ActionButtonItem(title: NSLocalizedString("Membership_Number", comment: ""), image: #imageLiteral(resourceName: "Membership-number"))
        membershipNumber.action = { item in
            let membershipController = UIStoryboard.loadStoryBoard(name:Storyboard.profile).instantiateViewController(withIdentifier: "ProfileMembershipViewController") as! ProfileMembershipViewController
            membershipController.isFromWallet = true
            membershipController.updateProfiles = {
                ProfileStatsViewController.fetchAllProfilesForKeysSync()
            }
            if let fromViewController = AppDelegate.shared().window?.rootViewController {
                // close menu
                self.actionButton.toggleMenu()
                fromViewController.addChildViewController(membershipController)
                membershipController.view.frame = fromViewController.view.frame
                fromViewController.view.addSubview(membershipController.view)
                membershipController.didMove(toParentViewController: fromViewController)
            }
        }
        actionButton = ActionButton(attachedToView: (AppDelegate.shared().window?.rootViewController?.view)!, items: [cart, history, membershipNumber])
        actionButton.action = { button in button.toggleMenu() }
        actionButton.setTitle("+", forState: UIControlState())
        actionButton.backgroundColor = UIColor.appOrange()
        hideActionButton(isHidden: true)
    }
    
    class func showActionButton() {
        actionButton.floatButton.isHidden = false
        actionButton.floatButton.isUserInteractionEnabled = true
        let cart = actionButton.items?[0]
        cart?.cartLabel.text = InvoiceManager.cartItemCount()
    }
    
    class func hideActionButton(isHidden : Bool) {
        actionButton.floatButton.isHidden = isHidden
    }
    
    //MARK:- Custom Alert View
    class func showCustomAlert(message: String, badgeImage: UIImage = #imageLiteral(resourceName: "congratulationsWorkout"), badgeImageURL: String = "", congratsMsg: String = NSLocalizedString("Congratulations", comment: ""), onClose:  CustomAlertView.closeHandler? = nil ) {
        customAlertView.setupCustomAlert(message: message, badgeImage: badgeImage, badgeImageURL: badgeImageURL, congratsMsg: congratsMsg)
        let windowView = AppDelegate.shared().window?.rootViewController?.view
        customAlertView.frame = CGRect(x: 0, y: 0, width: (windowView?.frame.size.width)!, height: (windowView?.frame.size.height)!)
        windowView?.addSubview(customAlertView)
        UIApplication.shared.statusBarStyle = .default
        customAlertView.closeButtonaTapped = {
            UIApplication.shared.statusBarStyle = .lightContent
            onClose?()
            //print("alertCloseHandler")
        }
    }
    
    //MARK:- Shows the map popup
    class func showPreviewMap(position: CLLocationCoordinate2D) {
        let mapPopupcontroller = UIStoryboard.loadStoryBoard(name:Storyboard.activity).instantiateViewController(withIdentifier: "MapPreviewViewController") as! MapPreviewViewController
        if let fromViewController = AppDelegate.shared().window?.rootViewController {
            fromViewController.addChildViewController(mapPopupcontroller)
            mapPopupcontroller.view.frame = fromViewController.view.frame
            fromViewController.view.addSubview(mapPopupcontroller.view)
            mapPopupcontroller.didMove(toParentViewController: fromViewController)
            mapPopupcontroller.addAnnotation(location: position)
        }
    }

    class func loadAppConfig() {
        do {
            if let file = Bundle.main.url(forResource: "config_\(Device.lang)", withExtension: "json") {
                let data = try Data(contentsOf: file)
               let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                appConfig = json
            } else {
                print("can't find a bundle for the app configuration")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
