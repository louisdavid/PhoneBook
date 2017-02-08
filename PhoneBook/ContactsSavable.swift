//
//  ContactsSavable.swift
//  PhoneBook
//
//  Created by Cote, Louis-David on 2017-02-07.
//  Copyright © 2017 Cote, Louis-David. All rights reserved.
//

import Foundation

protocol ContactsSavable {
    func SaveAContact(theContact:Contact, theIndexOfTheContact:Int!)
}
