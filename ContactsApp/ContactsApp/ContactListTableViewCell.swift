//
//  ContactListTableViewCell.swift
//  ContactsApp
//
//  Created by Radhika KS01 on 14/02/19.
//  Copyright © 2019 Radhika. All rights reserved.
//

import UIKit
import Kingfisher

class ContactListTableViewCell: UITableViewCell {

    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var favourite: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(contact: ContactDetail) {
        contactName.text = contact.fullName
        favourite.isHidden = !contact.favourite
        contactImage.kf.setImage(with: contact.profilePic, placeholder: UIImage(named: "placeholder_photo"))
    }

}
