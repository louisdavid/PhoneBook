//
//  Contact.swift
//  PhoneBook
//
//  Created by Cote, Louis-David on 2017-02-06.
//  Copyright © 2017 Cote, Louis-David. All rights reserved.
//

import Foundation
import CoreData

class Contact {
    var theName:String
    var theNumber:String
    var createdDateTime:Date //For future information on the contact
    var theAddress:String!
    var thePhoneType:PhoneType
    var theGender:Gender
    var theImageString:String!
    //var NSManagedObject:ContactEntity
    
    var phoneTypeAsInt:Int {
        get {
            switch self.thePhoneType {
            case .Home: return 0
            case .Work: return 1
            case .Mobile: return 2
            case .Fax: return 3
            }
        }
        set (newVal) {
            switch newVal {
            case 0: self.thePhoneType = .Home
            case 1: self.thePhoneType = .Work
            case 2: self.thePhoneType = .Mobile
            case 3: self.thePhoneType = .Fax
            default: self.thePhoneType = .Mobile
            }
        }
    }
    
    var phoneTypeAsString:String {
        get {
            return self.thePhoneType.rawValue
        }
    }
    
    var genderAsInt:Int {
        get {
            switch self.theGender {
            case .Other: return 0
            case .Male: return 1
            case .Female: return 2
            }
        }
        set (newVal) {
            switch newVal {
            case 0: self.theGender = .Other
            case 1: self.theGender = .Male
            case 2: self.theGender = .Female
            default: self.theGender = .Other
            }
        }
    }
    
    var genderAsString:String {
        get {
            return self.theGender.rawValue
        }
    }
    
    var thePhoneNumberAndTypeAsString:String {
        get {
            return self.theNumber + " (" + self.phoneTypeAsString + ")"
        }
    }
    
    var theNameAndGenderAsString:String {
        get {
            return self.theName + " (" + self.genderAsString + ")"
        }
    }
    
    var createdDateTimeAsString:String {
        get {
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.dateStyle = .medium
            return formatter.string(from: createdDateTime)
        }
    }
    
    init (theName:String, theNumber:String, theAddress:String="", thePhoneType:PhoneType = .Mobile, theGender:Gender = .Other, theImageString:String=""){
        self.theName = theName
        self.theNumber = theNumber
        self.createdDateTime = Date()
        self.theAddress = theAddress
        self.thePhoneType = thePhoneType
        self.theGender = theGender
        self.theImageString = theImageString
        //self.NSManagedObject = NSManagedObject
    }
    
    
    func validatePhoneNumber() -> Bool {
        let PHONE_REGEX = "^(?:\\+?1[-. ]?)?\\(?([0-9]{3})\\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self.theNumber)
        return result
    }
    
    func validateName() -> Bool {
        return self.theName.characters.count >= 3
    }
    
    func validateNameAndPhone() -> Bool {
        return (self.validateName() && self.validatePhoneNumber())
    }
}
