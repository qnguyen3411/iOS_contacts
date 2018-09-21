//
//  AddEditVC.swift
//  contacts
//
//  Created by Quang Nguyen on 9/20/18.
//  Copyright © 2018 Quang Nguyen. All rights reserved.
//

import UIKit

class AddEditVC: UIViewController {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    
    var contact:Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberField.delegate = self
        firstNameField.text = contact?.firstName ?? ""
        lastNameField.text = contact?.lastName ?? ""
        if let number = contact?.number {
            numberField.text = "\(number)"
        }
    }
    
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        if let contact = contact {
            if let validated = ContactModel.validatedData(firstName: firstNameField.text, lastName: lastNameField.text, numberStr: numberField.text) {
                contact.firstName = validated["firstName"] as? String
                contact.lastName = validated["lastName"] as? String
                contact.number = validated["number"] as! Int32
                ContactModel.saveContext()
            }
        } else {
            if let newContact = ContactModel.newContact(firstName: firstNameField.text, lastName: lastNameField.text, numberStr: numberField.text) {
                print("CONTACT IS SUCCESSFULLY CREATED: \(newContact)")
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

extension AddEditVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let _ = Int(string) {
            return true
        }
        return false
    }
}

extension AddEditVC: OptionallyTakesContactInfo {
    func setOptionalContact(_ contact: Contact?) {
        self.contact = contact
    }
}
