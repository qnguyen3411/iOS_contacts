//
//  ContactModel.swift
//  contacts
//
//  Created by Quang Nguyen on 9/20/18.
//  Copyright © 2018 Quang Nguyen. All rights reserved.
//

import UIKit
import CoreData

class ContactModel {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    static func fetchAllContacts() -> [[Contact]]{
        let contactKeys = ["A","B","C","D","E","F","G","H","I",
                           "J","K","L","M","N","O","P","Q","R",
                           "S","T","U","V","W","X","Y","Z"]
        
        var sectionedContact:[[Contact]] = []
        var allContacts:[Contact] = []
        let request:NSFetchRequest<Contact> = Contact.fetchRequest()
        
        do {
            allContacts = try context.fetch(request)
        } catch {
            print(error)
        }
        
        // Section the contracts
        for contactKey in contactKeys {
            let contactsForKey = allContacts.filter() {
                $0.firstName!.uppercased().first == contactKey.first
            }
            sectionedContact.append(contactsForKey)
        }
        return sectionedContact
    }
    
    static func newContact(firstName: String?, lastName: String?, numberStr: String?) -> Contact? {
        guard let validated = validatedData(firstName: firstName, lastName: lastName, numberStr: numberStr) else { return nil }
        
        let contact = Contact(context: context)
        contact.firstName = validated["firstName"] as? String
        contact.lastName = validated["lastName"] as? String
        contact.number = validated["number"] as! Int32
        saveContext()
        print("SUCCESS!")

        return contact
    }
    
    static func validatedData(firstName: String?, lastName: String?, numberStr: String?) -> [String:Any]? {
        guard let firstName = firstName else { return nil }
        guard let lastName = lastName else { return nil }
        guard let numberStr = numberStr else { return nil }
        guard let number = Int32(numberStr), numberStr.count >= 7 else { return nil }
        
        var data:[String:Any] = [:]
        data["firstName"] = firstName
        data["lastName"] = lastName
        data["number"] = number
        return data
    }
}
