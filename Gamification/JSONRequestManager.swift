//
//  JSONRequestManager.swift
//  CoreDirection
//
//  Created by Yasir Ali on 7/3/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import Alamofire

class JSONRequestManager: NSObject {
    
    typealias SuccessHandler = (Any?) -> Void
    typealias ErrorHandler = (NSError?) -> Void
    
    /***********************************************************************\
    |*                        GAMIFICATION REQUESTS                        *|
    \***********************************************************************/
    class func requestGamification(action method: String, parameters: Parameters, showProgress: Bool = false, onSuccess: @escaping SuccessHandler, onFailure: @escaping ErrorHandler)   {
        if ReachabilityManager.isReachable()   {
            if showProgress {
                // show progress
                HudView.showHudd()
            }
            Console.log(info: "URL: \(PSPointSystemAction.shared.baseUrl + method)\nParameters: \(parameters)", sender: self)
            Alamofire.request(PSPointSystemAction.shared.baseUrl + method + "", method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON { response in
                Console.log(info: String(describing: response.value), sender: self)
                if showProgress {
                    // hide progress
                    HudView.dismiss()
                }
                if let responseDictionary = response.value as? [String: Any]    {
                    let success = responseDictionary[Key.Response.success] as! Bool
                    if success  {
                        let data = responseDictionary[Key.Response.data]
                        Console.log(info: String(describing: data), sender: self)
                        onSuccess(data)
                        
                    }
                    else {
                        let errorDictionary : [String:Any] = [NSLocalizedDescriptionKey: "Gamification parser error"]
                        let parsingError = NSError(domain: "failure" , code: ResponseCode.gamificationParserError, userInfo: errorDictionary)

                        if let data = responseDictionary[Key.Response.data] as? [String: Any] {
                            if let infoDictionary = data[Key.Response.info] as? [String: Any] {
                                if let errorMessage = infoDictionary[Key.Response.message] as? String {
                                    let errorDictionary : [String:Any] = [NSLocalizedDescriptionKey: errorMessage]
                                    let error = NSError(domain: "failure" , code: ResponseCode.gamificationError, userInfo: errorDictionary)
                                    print(errorMessage)
                                    onFailure(error)
                                }else{
                                    print(parsingError.localizedDescription)
                                    onFailure(parsingError)
                                }
                            }else{
                                print(parsingError.localizedDescription)
                                onFailure(parsingError)
                            }
                        }else{
                            print(parsingError.localizedDescription)
                            onFailure(parsingError)
                        }
                    }
                }
                else    {
                    print(response.result.error!)
                    print(response.result.error!.localizedDescription)
                    Toast.show(message: NSLocalizedString("Unable_Process_Request", comment: ""), showInBottom : true)
                    onFailure(response.result.error as NSError?)
                }
            }
        }
        else    {
            // show internet not connected
            NetworkToast.show()
            let errorDictionary = [NSLocalizedDescriptionKey: "No Internet Connection"]
            let error = NSError(domain: "failure" , code: ResponseCode.noInternetError, userInfo: errorDictionary)
            onFailure(error)
        }
    }
}

