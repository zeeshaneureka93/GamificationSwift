//
//  User.swift
//  CoreDirection
//
//  Created by Muhammad Jabbar on 4/14/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import UIKit

enum Gender: String {
    case male = "male"
    case female = "female"
    case undefined = "undefined"
}
final class User: NSObject, NSCoding, ResponseObjectSerializable, ResponseListSerialzable {
    
    var id: Int = 0
    var firstName : String = ""
    var lastName : String = ""
    var email : String = ""
    var gender : Gender = .undefined
    var dateOfBirth : String = ""
    var joiningDate : String = ""
    var imageUrl : String = ""
    var phone : String = ""

    required override init() {
        super.init()
    }
    
    //MARK: ResponseObjectSerializable

    required convenience init?(response: HTTPURLResponse, representation: Any) {
        guard let representation = representation as? [String: Any] else { return nil   }
        self.init()
        self.initialize(response: response, representation: representation)
    }
        
    //MARK: Custom Initializer

    func initialize(response: HTTPURLResponse, representation: [String : Any]) {
        
        if let _id = representation[Key.User.id] as? Int   {
            id = _id
        }
        if let _firstName = representation[Key.User.firstName] as? String  {
            firstName = _firstName
        }
        if let _lastName = representation[Key.User.lastName] as? String  {
            lastName = _lastName
        }
        if let _email = representation[Key.User.email] as? String  {
            email = _email
        }
        if let _gender = representation[Key.User.gender] as? String  {
            gender = Gender(rawValue: _gender) ?? .undefined
        }
        if let _dateOfBirth = representation[Key.User.dateOfBirth] as? String  {
            dateOfBirth = _dateOfBirth
        }
        if let _joiningDate = representation[Key.User.joiningDate] as? String  {
            joiningDate = _joiningDate
        }
        if let _imageUrl = representation[Key.User.imageUrl] as? String  {
            imageUrl = _imageUrl
        }
        if let _phone = representation[Key.User.phone] as? String  {
            phone = _phone
        }
        
    }

    static func collection(response: HTTPURLResponse, representation: [[String : Any]]) -> [User] {
        var list = [User]()
        for subRepresentation in representation {
            print("\n User: \(subRepresentation)")
            let item = User(response: response, representation: subRepresentation)
            list.append(item!)
        }
        return list
    }
    
    //MARK: NSCoding
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.id = aDecoder.decodeInteger(forKey: Key.User.id)
        self.firstName = aDecoder.decodeObject(forKey: Key.User.firstName) as? String ?? ""
        self.lastName = aDecoder.decodeObject(forKey: Key.User.lastName) as? String ?? ""
        self.email = aDecoder.decodeObject(forKey: Key.User.email) as? String ?? ""
        if let gend = aDecoder.decodeObject(forKey: Key.User.gender)  as? String{
            self.gender = Gender(rawValue: gend) ?? .undefined
        }
        self.dateOfBirth = aDecoder.decodeObject(forKey: Key.User.dateOfBirth) as? String ?? ""
        self.joiningDate = aDecoder.decodeObject(forKey: Key.User.joiningDate) as? String ?? ""
        self.imageUrl = aDecoder.decodeObject(forKey: Key.User.imageUrl) as? String ?? ""
        self.phone = aDecoder.decodeObject(forKey: Key.User.phone) as? String ?? ""

    }
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.id, forKey: Key.User.id)
        aCoder.encode(self.firstName, forKey: Key.User.firstName)
        aCoder.encode(self.lastName, forKey: Key.User.lastName)
        aCoder.encode(self.email, forKey: Key.User.email)
        aCoder.encode(self.gender.rawValue, forKey: Key.User.gender)
        aCoder.encode(self.dateOfBirth, forKey: Key.User.dateOfBirth)
        aCoder.encode(self.joiningDate, forKey: Key.User.joiningDate)
        aCoder.encode(self.imageUrl, forKey: Key.User.imageUrl)
        aCoder.encode(self.phone, forKey: Key.User.phone)
    }
}

