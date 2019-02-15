//
//  Constants.swift
//  ContactsApp
//
//  Created by Radhika KS01 on 14/02/19.
//  Copyright © 2019 Radhika. All rights reserved.
//

import Foundation

class Constants {
    struct URL {
        static let Base = "​http://gojek-contacts-app.herokuapp.com/"
        static let ContactList = "\(Base)contacts.json"
    }
    
    enum ContactCellType: Int {
        case mobile
        case email
    }
}
