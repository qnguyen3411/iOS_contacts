//
//  MainVC.swift
//  contacts
//
//  Created by Quang Nguyen on 9/20/18.
//  Copyright © 2018 Quang Nguyen. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    let contactKeys = ["A","B","C","D","E","F","G","H","I",
                       "J","K","L","M","N","O","P","Q","R",
                       "S","T","U","V","W","X","Y","Z"]
    
    var contacts = [[Contact]](repeating: [], count: 26)
    var searchResults: [Contact] = []
    
    var nonEmptySections: [String] {
        let filteredKeys =  contactKeys.filter() { sectionKey in
            let contactsForKey = contacts(forKey: sectionKey)
            return !contactsForKey.isEmpty
        }
        return filteredKeys
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewWillAppear(_ animated: Bool) {
        searchDisplayController?.setActive(false, animated: false)
        contacts = ContactModel.fetchAllContacts()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Button events
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddEditSegue", sender: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nav = segue.destination as? UINavigationController else { return }
        guard let destination = nav.topViewController as? OptionallyTakesContactInfo else { return }
        destination.setOptionalContact(sender as? Contact)
    }
    
    // MARK: - Helper
    
    func contacts(forKey sectionKey: String) -> [Contact] {
        let sectionIndex = contactKeys.firstIndex { $0 == sectionKey}
        return contacts[sectionIndex!]
    }
    
    func contact(forIndexPath indexPath: IndexPath) -> Contact {
        let sectionKey = nonEmptySections[indexPath.section]
        let contactsForKey = contacts(forKey: sectionKey)
        return contactsForKey[indexPath.row]
    }
    
    func contact(for tableView: UITableView, at indexPath: IndexPath) -> Contact? {
        var thisContact:Contact?
        if tableView == self.searchDisplayController?.searchResultsTableView {
            thisContact = self.searchResults[indexPath.row]
        } else {
            thisContact = self.contact(forIndexPath: indexPath)
        }
        return thisContact
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == searchDisplayController?.searchResultsTableView {
            return 1
        }
        return nonEmptySections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = .lightGray

        if tableView == searchDisplayController?.searchResultsTableView {
            label.text = "   Top matches:"
        } else {
            label.text = "   " + nonEmptySections[section]
        }
        return label
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchDisplayController?.searchResultsTableView {
            if searchBar.text != "" {
                return searchResults.count
            } else {
                return 0
            }
        }
        let sectionKey = nonEmptySections[section]
        return contacts(forKey: sectionKey).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        var thisContact:Contact?
        
        if tableView == searchDisplayController?.searchResultsTableView {
            cell = UITableViewCell()
            thisContact = searchResults[indexPath.row]
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell")
            thisContact = contact(forIndexPath: indexPath)
        }
        
        cell!.textLabel?.text = thisContact?.fullName
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thisContact = self.contact(for: tableView, at: indexPath)
        performSegue(withIdentifier: "MainToDisplaySegue", sender: thisContact)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delAction = UIContextualAction(style: .destructive, title: "Delete") { _,_,_  in
            
            if let thisContact = self.contact(for: tableView, at: indexPath) {
                self.searchResults.remove(at: indexPath.row)
                ContactModel.context.delete(thisContact)
            }
            
            self.contacts = ContactModel.fetchAllContacts()
            ContactModel.saveContext()
            
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _,_,_ in
            let thisContact = self.contact(for: tableView, at: indexPath)
            self.performSegue(withIdentifier: "AddEditSegue", sender: thisContact)
        }
        return UISwipeActionsConfiguration(actions: [delAction, editAction])
    }
}

extension MainVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let query = searchBar.text, query.count != 0 {
            let allContacts = contacts.flatMap { $0 }
            let filteredContacts = allContacts.filter() { contact in
                return contact.fullName.containsIgnoringCase(find: query)
            }
            searchResults = filteredContacts
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }

}
