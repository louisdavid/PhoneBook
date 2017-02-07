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
    let createdDate:Date
    
    var createdDateAsString:String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        return formatter.string(from: createdDate)
    }
    
    init(theName:String, theNumber:String) {
        self.theName = theName
        self.theNumber = theNumber
        self.createdDate = Date()
    }
}
