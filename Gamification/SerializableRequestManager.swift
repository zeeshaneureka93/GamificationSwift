//
//  SerializableRequestManager.swift
//  CoreDirection
//
//  Created by Yasir Ali on 4/11/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import Alamofire


class SerializableRequestManager<T: ResponseObjectSerializable>: NSObject {
    typealias ErrorHandler = (NSError?) -> Void
    typealias TSuccessHandler = (T?) -> Void
    typealias SuccessHandler = (Any?) -> Void
    
    class func handleErrors(baseUrl : String, method : String,headers: [String: String]?,parameters: Parameters,response: Data? = nil,responseError : Error?) {

        if let error = responseError as? AFError  {
            switch error {
            case .invalidURL(let url):
                print("Invalid URL: \(url) - \(error.localizedDescription)")
            case .parameterEncodingFailed(let reason):
                print("Parameter encoding failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
            case .multipartEncodingFailed(let reason):
                print("Multipart encoding failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
            case .responseValidationFailed(let reason):
                print("Response validation failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
                switch reason {
                case .dataFileNil, .dataFileReadFailed:
                    print("Downloaded file could not be read")
                case .missingContentType(let acceptableContentTypes):
                    print("Content Type Missing: \(acceptableContentTypes)")
                case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                    print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                case .unacceptableStatusCode(let code):
                    print("Response status code was unacceptable: \(code)")
                }
            case .responseSerializationFailed(let reason):
                print("Response serialization failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
            }
            if error._code != URLError.networkConnectionLost.rawValue  && error._code != URLError.cannotConnectToHost.rawValue && error._code != URLError.timedOut.rawValue && error._code != URLError.notConnectedToInternet.rawValue  {
                if method != API.errorLog {
//                    self.logError(url: baseUrl + method, headers: headers, parameters:parameters, errorString: error.failureReason ?? error.localizedDescription)
                }
            }
            print("Underlying error: \(String(describing: error.underlyingError))")
        } else if let error = responseError as? URLError {
            print("URLError occurred: \(error)")
            if error._code != URLError.networkConnectionLost.rawValue  && error._code != URLError.cannotConnectToHost.rawValue && error._code != URLError.timedOut.rawValue && error._code != URLError.notConnectedToInternet.rawValue{
                if method != API.errorLog {
//                    self.logError(url: baseUrl + method, headers: headers, parameters:parameters, errorString: error.failureURLString ?? error.localizedDescription)
                }
            }
            
        } else if let error = responseError as NSError? {
            print("Unknown error: \(error)")
            if error._code != URLError.networkConnectionLost.rawValue  && error._code != URLError.cannotConnectToHost.rawValue && error._code != URLError.timedOut.rawValue && error._code != URLError.notConnectedToInternet.rawValue{
                if method != API.errorLog {
//                    self.logError(url: baseUrl + method, headers: headers, parameters:parameters, errorString: error.localizedFailureReason ?? error.localizedDescription)
                }
            }
        }else{
            Toast.show(message: NSLocalizedString("Unable_Process_Request", comment: ""))
        }
    }
    
    fileprivate class func convertToJsonString(json: [String: Any]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }

    private class func authorizationHeaders() -> HTTPHeaders? {
        let credentialData = "\(Server.Authorization.username):\(Server.Authorization.password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let base64EncodedAuthUsernamePassword = "\(Server.Authorization.type)\(base64Credentials)"
        var headers : [String:String] = [Key.User.authorization: base64EncodedAuthUsernamePassword,
                                       Key.User.deviceToken: "", Key.User.deviceType: "iphone",
                                       "version": Bundle.main.releaseVersionNumber ?? "", "build": Bundle.main.buildVersionNumber ?? "",
                                       Key.User.lang: Device.lang, Key.User.encryption: "false", Key.User.compression: "false"]
        if let sessionInfo = SessionManager.getInfo() {
            headers[Key.User.userIdCaps] = "\(sessionInfo.userId)"
            headers[Key.User.userAuthorization] = sessionInfo.sessionToken
            if let user = SessionManager.user {
                if user.isNotificationEnabled {
//                    headers[Key.User.deviceToken] =  AppDelegate.shared().deviceToken
                }
            }
        }
        return headers
    }
}

