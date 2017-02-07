//
//  ViewController.swift
//  PhoneBook
//
//  Created by Cote, Louis-David on 2017-02-06.
//  Copyright © 2017 Cote, Louis-David. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        theContactsList.append(Contact(theName: "Jack Burns", theNumber: "1-514-819-5124"))
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var tableView: UITableView!
    var theContactsList = [Contact]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    
}

// Function Validation
extension ViewController {
    //Validates if the string is a phone number or not
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^(?:\\+?1[-. ]?)?\\(?([0-9]{3})\\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    func isValid(nameCount:Int, numberString:String)->Bool {
        if ( nameCount >= 3) { 
            if (validate(value: numberString)){
                return true
            }
        }
        return false
    }
}

// Event Handlers
extension ViewController {
    func textFieldDidChange(textField:UITextField) {
        let theController = self.presentedViewController as? UIAlertController
        let text1 = theController?.textFields?.first?.text
        let text2 = theController?.textFields?.last?.text
        theController?.actions.last?.isEnabled = isValid(nameCount: text1!.characters.count, numberString: text2!)
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
        })
        addAlert.addAction(addAction)
        
        //Set the Add button to disable to not add blank textfields
        addAction.isEnabled = false
        
        //Add Handler to Alert
       // let textField1 = addAlert.textFields?.first
       // let textField2 = addAlert.textFields?.last
        addAlert.textFields?.first?.addTarget(self, action: #selector(textFieldDidChange(textField: )), for: .editingChanged)
        addAlert.textFields?.last?.addTarget(self, action: #selector(textFieldDidChange(textField: )), for: .editingChanged)

        //Send the Alert To the Screen
        present(addAlert, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let theCell = self.tableView.dequeueReusableCell(withIdentifier: "TheCell", for: indexPath)
        theCell.textLabel?.text = self.theContactsList[indexPath.row].theName
        theCell.detailTextLabel?.text = self.theContactsList[indexPath.row].theNumber
        return theCell
    }
}

//Delegate Methods
extension ViewController {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.theContactsList.remove(at: indexPath.row)
        }
    }
}
