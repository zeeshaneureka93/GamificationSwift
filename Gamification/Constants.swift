//
//  Constants.swift
//  CoreDirection
//
//  Created by Yasir Ali on 4/11/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import Foundation

// Should Choose User Selected Language or iOS
let isPreferredLanguageiOS = true

// Cofigure List of Supported languages here
let listOfSupportedLanguages = ["en"]//["en", "ar"]
let defaultLanguage = "en"

var lastUserSelectedLanguageCode = UserDefaults.standard.value(forKey: "UserLastSelectedLanguage") as? String ?? defaultLanguage

let currentLangugageCode = isPreferredLanguageiOS ? (Locale.current.languageCode ?? defaultLanguage) : lastUserSelectedLanguageCode

let currentLanguage = listOfSupportedLanguages.contains(currentLangugageCode) ? currentLangugageCode : defaultLanguage

let defaultLocale = Locale(identifier: "en_US_POSIX")
let currentLocale : Locale = {
    if  listOfSupportedLanguages.contains(Locale.current.languageCode ?? "") {
        return Locale.current
    }
    return defaultLocale
}()


let serverLocale = defaultLocale
var errorLogEnabled = true
let exceptionFound = "exceptionFound"


// MARK:- API Configuration

struct ResponseCode {
    // 200: Success
    // 207: Validation errors. i.e Field required
    // 401: Unauthorized request
    // 403: Forbidden
    // 404: Content not found.
    // 405: Not Enabled    Account not activated
    // 300: Already Exist    Already used
    
    static let ok = 200
    static let validationError = 207//394
    static let alreadyExists = 300
    static let unauthorized = 401
    static let forbidden = 403
    static let noDataFound = 404
    static let accountInActive = 405
    
    static let gamificationError = 1111
    static let noInternetError = 100
    static let gamificationParserError = 101
    
    static let invalidUser = 422

}
