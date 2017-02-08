//
//  Contact.swift
//  PhoneBook
//
//  Created by Cote, Louis-David on 2017-02-06.
//  Copyright © 2017 Cote, Louis-David. All rights reserved.
//

import Foundation

class Contact {
    var theName:String
    var theNumber:String
    let createdDateTime:Date //For future information on the contact
    var theAddress:String!
    var thePhoneType:PhoneType
    
    var createdDateTimeAsString:String {
        get {
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.dateStyle = .medium
            return formatter.string(from: createdDateTime)
        }
    }
    
    var phoneTypeAsString:String {
        get {
            return self.thePhoneType.rawValue
        }
    }
    
    init (theName:String, theNumber:String, theAddress:String="", thePhoneType:PhoneType = .Mobile){
        self.theName = theName
        self.theNumber = theNumber
        self.createdDateTime = Date()
        self.theAddress = theAddress
        self.thePhoneType = thePhoneType
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
