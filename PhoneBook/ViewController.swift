//
//  ViewController.swift
//  PhoneBook
//
//  Created by Cote, Louis-David on 2017-02-06.
//  Copyright © 2017 Cote, Louis-David. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ContactsSavable {
    
    var mangedContextObject = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func SaveAContact(theContact: Contact, theIndexOfTheContact: Int!) {
        if let _ = theIndexOfTheContact {
            self.theContactsList[theIndexOfTheContact] = theContact
        } else {
            self.theContactsList.append(theContact)
        }
        self.saveCD()
    }
    
    //Load CoreData
    func loadContactFromCoreData() {
        let theFetchRequest:NSFetchRequest<ContactEntity> = ContactEntity.fetchRequest()
        
        do {
            for aContactEntity in try self.mangedContextObject.fetch(theFetchRequest) {
                let aContact = Contact(theName: aContactEntity.theName!, theNumber: aContactEntity.theNumber!, theAddress: aContactEntity.theAddress!)
                aContact.createdDateTime = aContactEntity.createdDateTime as! Date
                aContact.theImageString = aContactEntity.theImageString!
                aContact.theAddress = aContactEntity.theAddress!
                
                switch aContactEntity.theGender! {
                    case "Other": aContact.theGender = .Other
                    case "Male": aContact.theGender = .Male
                    case "Female": aContact.theGender = .Female
                    default: aContact.theGender = .Other
                }
                switch aContactEntity.thePhoneType! {
                    case "Home": aContact.thePhoneType = .Home
                    case "Work": aContact.thePhoneType = .Work
                    case "Mobile": aContact.thePhoneType = .Mobile
                    case "Fax": aContact.thePhoneType = .Fax
                    default: aContact.thePhoneType = .Mobile
                }
                
                self.theContactsList.append(aContact)
            }
        } catch {
            print("Error loading a Contact Entity from CoreData - \(error.localizedDescription)")
        }
    
    }
    
    @IBOutlet weak var tableView: UITableView!
    var theContactsList = [Contact]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadContactFromCoreData()
        // Do any additional setup after loading the view, typically from a nib.
        //theContactsList.append(Contact(theName: "Jack Burns", theNumber: "1-514-819-5124", theGender: .Male, theImageString: "1"))
        //theContactsList.append(Contact(theName: "te", theNumber: "1-514-819-5124"))
        //theContactsList.append(Contact(theName: "User Test Validation", theNumber: "1-514-ABC-5124", theAddress: "John Abbot College Residence"))
        //theContactsList.append(Contact(theName: "Work", theNumber: "1-514-123-5124", thePhoneType: .Work, theGender: .Female))
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// Function Validation
extension ViewController {
    func isValid(nameString:String, numberString:String)->Bool {
        let isContactValid = Contact(theName: nameString, theNumber: numberString)
        return isContactValid.validateNameAndPhone()

    }
}

// Event Handlers
extension ViewController {
    func textFieldDidChange(textField:UITextField) {
        let theController = self.presentedViewController as? UIAlertController
        let isContactValid = Contact(theName: (theController?.textFields?.first?.text)!, theNumber: (theController?.textFields?.last?.text)!)
        theController?.actions.last?.isEnabled = isContactValid.validateNameAndPhone()
    }
}

// Button Actions
extension ViewController {
    @IBAction func addContact(_ sender: UIBarButtonItem) {
        //CREATE ALERT
        let addAlert = UIAlertController(title: "Name And Phone", message: "Please enter Name and Phone Number...", preferredStyle: .alert)
        
        //ADD Cancel Button To Alert
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addAlert.addAction(cancelAction)
        
        //ADD Text Fields with Subtext to Alert
        addAlert.addTextField(configurationHandler: nil)
        addAlert.textFields?.last?.attributedPlaceholder = NSAttributedString(string: "Name (3 or more chars)")
        addAlert.addTextField(configurationHandler: nil)
        addAlert.textFields?.last?.attributedPlaceholder = NSAttributedString(string: "Phone Number(10-14 Chars)")
        
        //ADD a button to Alert and add the textfields to a list
        let addAction = UIAlertAction(title: "Add", style: .default, handler: { (_) in
            guard let theName = addAlert.textFields?.first?.text, let theNumber = addAlert.textFields?.last?.text
                else{
                    return
            }
            //add to the list of contacts
            self.theContactsList.append(Contact(theName: theName, theNumber: theNumber))
            self.saveCD()
            
        })
        addAlert.addAction(addAction)
        
        //Set the Add button to disable to not add blank textfields
        addAction.isEnabled = false
        
        //Add Handler to Alert
        addAlert.textFields?.first?.addTarget(self, action: #selector(textFieldDidChange(textField: )), for: .editingChanged)
        addAlert.textFields?.last?.addTarget(self, action: #selector(textFieldDidChange(textField: )), for: .editingChanged)

        //Send the Alert To the Screen
        present(addAlert, animated: true, completion: nil)
    }
}

//Save Contact To CoreData
extension ViewController {
    func saveCD() {
        let theContactEntity = ContactEntity(context: self.mangedContextObject)
        
        theContactEntity.theName = self.theContactsList.last?.theName
        theContactEntity.createdDateTime = self.theContactsList.last?.createdDateTime as NSDate?
        theContactEntity.theNumber = self.theContactsList.last?.theNumber
        theContactEntity.theAddress = self.theContactsList.last?.theAddress
        theContactEntity.theGender = self.theContactsList.last?.genderAsString
        theContactEntity.thePhoneType = self.theContactsList.last?.phoneTypeAsString
        theContactEntity.theImageString = self.theContactsList.last?.theImageString
        
        do {
            try self.mangedContextObject.save()
        } catch {
            print("Error saving a Contact to CoreData - \(error.localizedDescription)")
        }
    }
}




// DataSource Methods
extension ViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.theContactsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let _ = UIImage(named: self.theContactsList[indexPath.row].theImageString) {
            return 100.0
        } else {
            return 50.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //Set The Cell with the correct Prototype Cell
        if let _ =  UIImage(named: self.theContactsList[indexPath.row].theImageString) {
            let theCell = self.tableView.dequeueReusableCell(withIdentifier: "theCellWithImage", for: indexPath) as! TableViewCellWithIcon
            theCell.theImageView.image = UIImage(named: self.theContactsList[indexPath.row].theImageString)
            theCell.theTitle.text = self.theContactsList[indexPath.row].theNameAndGenderAsString
            theCell.theSubtitle.text = self.theContactsList[indexPath.row].thePhoneNumberAndTypeAsString
            return theCell
        }else {
            let theCell = self.tableView.dequeueReusableCell(withIdentifier: "theCellWithNoImage", for: indexPath) as! TableViewCellWithoutIcon
            theCell.theTitle.text = self.theContactsList[indexPath.row].theNameAndGenderAsString
            theCell.theSubtitle.text = self.theContactsList[indexPath.row].thePhoneNumberAndTypeAsString
            return theCell
        }
    }
}

//Delegate Methods
extension ViewController {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.theContactsList.remove(at: indexPath.row)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let theNextViewController = segue.destination as! EditViewController
        theNextViewController.objToSaveTo = self
        if segue.identifier == "EditSegue" {
            if let indexPath = self.tableView.indexPathsForSelectedRows?[0] {
                theNextViewController.theContact = self.theContactsList[indexPath.row]
                theNextViewController.indexOfContact = indexPath.row
            }
        }
    }
}
