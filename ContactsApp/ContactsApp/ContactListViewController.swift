//
//  ContactListViewController.swift
//  ContactsApp
//
//  Created by Radhika KS01 on 2019-02-13.
//  Copyright © 2019 Radhika. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ContactListViewController: UIViewController {
    
    @IBOutlet var activityIndicator: UIView!
    @IBOutlet weak var contactsTableView: UITableView!
    var keysArray = [String]()
    {
        didSet{
            contactsTableView.reloadData()
        }
    }
    var contactsDict = [String:[ContactDetail]]()
    {
        didSet{
            keysArray = Array(contactsDict.keys).sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        // Do any additional setup after loading the view.
    }
    
    func initialSetup() {
        self.getContactsFromServer()
//        self.contactsTableView.tableFooterView = UIView()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let destinationVC = segue.destination as? ContactDetailsViewController, let contact = sender as? ContactDetail {
            destinationVC.contact = contact
        }
        
        
    }
   
    
    func getContactsFromServer() {
        
        self.contactsTableView.tableFooterView = activityIndicator
        Alamofire.request("http://gojek-contacts-app.herokuapp.com/contacts.json", method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                debugPrint(response)
                self.contactsTableView.tableFooterView = UIView()
                if let data = response.data
                {
                    do
                    {
                        let json = try JSON(data: data)
                        if let contacts = json.array {
                            let contactsArray = contacts.compactMap {
                                ContactDetail(json: $0)
                            }
                            self.contactsDict = Dictionary(grouping: contactsArray, by: {$0.fullName.firstCharacter})
                            
                        }
                        
                    }
                    catch {
                        //                        print(e)
                    }
                }
        }
    }
    

}

extension ContactListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = keysArray[section]
        if let contactsArray = contactsDict[key] {
            return contactsArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactListTableViewCell
        let key =  keysArray[indexPath.section]
        cell.configureCell(contact: contactsDict[key]![indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return keysArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keysArray[section].capitalized
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return keysArray
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key =  keysArray[indexPath.section]       
        self.performSegue(withIdentifier: "contactDetail", sender: contactsDict[key]![indexPath.row])
    }
}

extension String {
    
    var firstCharacter: String
    {
        get {
            if let character = self.first {
                return String(character).capitalized
            }
            return ""
        }
    }
    
   
    
}
