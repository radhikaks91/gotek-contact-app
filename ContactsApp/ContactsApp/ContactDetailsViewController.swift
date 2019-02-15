//
//  ContactDetailsViewController.swift
//  ContactsApp
//
//  Created by Radhika KS01 on 2019-02-14.
//  Copyright © 2019 Radhika. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import SwiftyJSON

class ContactDetailsViewController: UIViewController {
    
    var contact: ContactDetail?
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var contactDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContact()
        // Do any additional setup after loading the view.
    }
    
    func configureContact() {
        if let contact = self.contact {
            self.contactNameLabel.text = contact.fullName
            self.contactImage.kf.setImage(with: contact.profilePic, placeholder: UIImage(named: "placeholder_photo"))
            self.favouriteButton.isSelected = contact.favourite
            self.getContactDetailsFromServer()
        }
        self.contactDetailTableView.tableFooterView = UIView()
    }
    
    func getContactDetailsFromServer()  {
        Alamofire.request((contact?.url)!, method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                debugPrint(response)
                
                if let data = response.data
                {
                    do
                    {
                        let json = try JSON(data: data)
                        self.contact?.updateContactDetails(json: json)
                        self.contactDetailTableView.reloadData()
                    }
                    catch {
                        //                        print(e)
                    }
                }
        }
    }

    
    @IBAction func messageContact(_ sender: Any) {
    }
    
    @IBAction func callContact(_ sender: Any) {
    }
    
    @IBAction func emailContact(_ sender: Any) {
    }
    
    @IBAction func setFavourite(_ sender: UIButton) {
        favouriteButton.isSelected = !favouriteButton.isSelected
        self.updateContactDetails()
    }
    
    func updateContactDetails()  {
        
        guard contact != nil else {
            return
        }
        
        var parameters = [String: Any]()
        parameters["favorite"] = false//NSNumber(value: !contact!.favourite)
        parameters["first_name"] = contact?.firstName
        //parameters[] = contact?.id
        parameters["last_name"] = contact?.lastName
        parameters["phone_number"] = contact?.phoneNumber
        parameters["email"] = contact?.email
        parameters["profile_pic"] = contact?.profilePic?.absoluteString
        parameters["updated_at"] = contact?.updatedAt
        parameters["created_at"] = contact?.createdAt
        
        Alamofire.request(URL(string: contact!.url!)!, method: .put, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON
            { (response) in
            debugPrint(response)
            // Handle your response
        }
        
//        Alamofire.request(<#T##urlRequest: URLRequestConvertible##URLRequestConvertible#>)
//
//        Alamofire.request(.put, contact?.url, parameters: parameters, encoding: .default, headers: nil)
//            .responseJSON { response in
//                debugPrint(response)
//
//                if let data = response.data
//                {
//                    do
//                    {
//                        let json = try JSON(data: data)
//                        self.contact?.updateContactDetails(json: json)
//                        self.contactDetailTableView.reloadData()
//                    }
//                    catch {
//                        //                        print(e)
//                    }
//                }
//
//        Alamofire.request((contact?.url)!, method: .put, encoding: JSONEncoding.default)
//            .responseJSON { response in
//                debugPrint(response)
//
//                if let data = response.data
//                {
//                    do
//                    {
//                        let json = try JSON(data: data)
//                        self.contact?.updateContactDetails(json: json)
//                        self.contactDetailTableView.reloadData()
//                    }
//                    catch {
//                        //                        print(e)
//                    }
//                }
//        }
    }
    
    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ContactDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "contactDetailCell", for: indexPath)
        
        if let label = cell.viewWithTag(101) as? UILabel {
            label.text = indexPath.row == Constants.ContactCellType.mobile.rawValue ? "mobile" : "email"
        }
        
        if let value = cell.viewWithTag(102) as? UILabel {
            value.text = indexPath.row == Constants.ContactCellType.mobile.rawValue ? contact?.phoneNumber : contact?.email
        }
        return cell
    }
    
    
    
}
