//
//  EditViewController.swift
//  PhoneBook
//
//  Created by Cote, Louis-David on 2017-02-07.
//  Copyright © 2017 Cote, Louis-David. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var theTextView: UITextView!
    @IBOutlet weak var thePhoneText: UITextField!
    @IBOutlet weak var theNameText: UITextField!
    @IBOutlet weak var thePhoneType: UISegmentedControl!
    @IBOutlet weak var thePhoneSegmented: UISegmentedControl!
    @IBOutlet weak var theGenderSegmented: UISegmentedControl!
    @IBOutlet weak var theImageView: UIImageView!
    
    var objToSaveTo:ContactsSavable!
    var theContact:Contact!
    var indexOfContact:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Defaults
        self.SaveButton.isEnabled = self.theContact.validateNameAndPhone()
        self.thePhoneType.selectedSegmentIndex = 2
        self.theTextView.layer.borderWidth = 0.5
        self.theTextView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        self.theTextView.layer.cornerRadius = 5.0
        self.theImageView.backgroundColor = UIColor.lightGray
        
        //Set Edit Contact Information screen
        self.theNameText.text = self.theContact.theName
        self.thePhoneText.text = self.theContact.theNumber
        self.theTextView.text = self.theContact.theAddress
        self.thePhoneSegmented.selectedSegmentIndex = self.theContact.phoneTypeAsInt
        self.theGenderSegmented.selectedSegmentIndex = self.theContact.genderAsInt
        if let name = self.theContact.theImageString {
            self.theImageView.image = UIImage(named: name)
        }

        //Add Event Handlers for the name and phone textfields
        self.thePhoneText.addTarget(self, action: #selector(textFieldDidChange(textField: )), for: .editingChanged)
        self.theNameText.addTarget(self, action: #selector(textFieldDidChange(textField: )), for: .editingChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

//Button Methods
extension EditViewController {
    @IBAction func doSave(_ sender: UIButton) {
        self.theContact.theName = self.theNameText.text!
        self.theContact.theNumber = self.thePhoneText.text!
        self.theContact.theAddress = self.theTextView.text!
        self.theContact.phoneTypeAsInt = self.thePhoneSegmented.selectedSegmentIndex
        self.theContact.genderAsInt = self.theGenderSegmented.selectedSegmentIndex
        self.objToSaveTo.SaveAContact(theContact: self.theContact, theIndexOfTheContact: self.indexOfContact)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func doCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

//Event Handler
extension EditViewController {
    func textFieldDidChange(textField:UITextField) {
        let isContactValid = Contact(theName: self.theNameText.text!, theNumber: self.thePhoneText.text!)
        self.SaveButton.isEnabled = isContactValid.validateNameAndPhone()
    }
}
