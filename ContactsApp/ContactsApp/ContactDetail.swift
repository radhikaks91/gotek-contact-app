//
//  ContactDetail.swift
//  ContactsApp
//
//  Created by Radhika KS01 on 14/02/19.
//  Copyright © 2019 Radhika. All rights reserved.
//

import UIKit
import SwiftyJSON

class ContactDetail: NSObject {
    var id: Int
    var firstName: String?
    var lastName: String?
    var email: String?
    var phoneNumber: String?
    var profilePic: URL?
    var favourite = false
    var createdAt: String?
    var updatedAt: String?
    var fullName = ""
    var url: String?
    
    init?(json: JSON)
    {
        if let id = json["id"].int
        {
            self.id = id
            self.firstName = json["first_name"].string
            self.lastName = json["last_name"].string
            self.email = json["email"].string
            self.phoneNumber = json["phone_number"].string
            
            if let profileImageURL = json["profile_pic"].string {
                 self.profilePic = URL(string: "\(profileImageURL)")
            }
            
            self.favourite = json["favorite"].intValue == 1
            self.createdAt = json["created_at"].string
            self.updatedAt = json["last_name"].string
            let firstName = self.firstName ?? ""
            let lastName = self.lastName ?? ""
            self.fullName = firstName + " " + lastName
            self.url = json["url"].string
        }
        else
        {
            return nil
        }
        
    }
    
    func updateContactDetails(json: JSON) {
        self.email = json["email"].string
        self.phoneNumber = json["phone_number"].string
    }
}


