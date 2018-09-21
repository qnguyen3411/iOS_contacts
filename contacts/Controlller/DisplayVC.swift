//
//  DisplayVC.swift
//  contacts
//
//  Created by Quang Nguyen on 9/20/18.
//  Copyright © 2018 Quang Nguyen. All rights reserved.
//

import UIKit

class DisplayVC: UIViewController {
    
    var contact: Contact?
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var lastNameLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        firstNameLabel.text = contact?.firstName ?? ""
        lastNameLabel.text = contact?.lastName ?? ""
        if let number = contact?.number {
            numberLabel.text = "\(number)"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "DisplayToAddEditSegue", sender: contact)
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nav = segue.destination as? UINavigationController else { return }
        guard let destination = nav.topViewController as? AddEditVC else { return }
        
        if let contact = sender as? Contact {
            destination.contact = contact
        }
    }
}

extension DisplayVC: OptionallyTakesContactInfo {
    func setOptionalContact(_ contact: Contact?) {
        self.contact = contact
    }
}
