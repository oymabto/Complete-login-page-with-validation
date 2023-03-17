//
//  ListOfUsersAfterLoginTableViewController.swift
//  Alireza
//
//  Created by Alireza on 2023-03-15.
//

import UIKit

protocol ListOfUsersAfterLoginTableViewControllerDelegate: AnyObject {
// Defines a delegate protocol that must be implemented by a class, as indicated by the AnyObject constraint.
    
    func updateLoggedInUsers(_ loggedInUsers: [User])
    // Declares a method that takes an array of User objects and returns nothing. This method must be implemented by classes conforming to the ListOfUsersAfterLoginTableViewControllerDelegate protocol.
}

class ListOfUsersAfterLoginTableViewController: UITableViewController {
    
    var loggedInUsers = [User]()
    // Declares a property named loggedInUsers, an array of User objects, and initializes it as an empty array.
    
    weak var delegate: ListOfUsersAfterLoginTableViewControllerDelegate?
    // Declares a weak optional property named delegate of type ListOfUsersAfterLoginTableViewControllerDelegate
    
    weak var loginViewControllerDelegate: UpdatePasswordViewControllerDelegate?
    // Declares another weak optional property named loginViewControllerDelegate of type UpdatePasswordViewControllerDelegate.

    @IBOutlet weak var changePasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserCell")
        // Registers a UITableViewCell class for use in the table view when dequeuing cells with the reuse identifier "UserCell".
        // tableView refers to the UITableView instance that is part of the UITableViewController subclass (ListOfUsersAfterLoginTableViewController). The UITableView is responsible for displaying the rows of data in a scrollable list.
        // .register is to register a specific UITableViewCell subclass for use when dequeuing cells with a given reuse identifier.
        // This ensures that when you request a cell for a specific identifier, the table view knows which class to instantiate or reuse.
        // UITableViewCell.self is the UITableViewCell class itself, not an instance of the class.
        // Since UITableViewCell is a basic, built-in cell type provided by UIKit, you don't need to create a custom subclass for this specific case. By passing UITableViewCell.self, you are telling the table view to use the default UITableViewCell class when dequeuing cells with the "UserCell" identifier.
        // forCellReuseIdentifier is the parameter name for the method, indicating that the following string will be used as the reuse identifier.
        // "UserCell" is the string that represents the reuse identifier for cells of type UITableViewCell. When you dequeue a cell later in your code, you will use this same identifier to request a cell of this type.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.updateLoggedInUsers(loggedInUsers)
        // If the delegate property has a value (i.e., it is not nil), the updateLoggedInUsers method will be called on the delegate object with the updated list of logged-in users as its parameter. This allows the delegate object, typically another view controller, to handle the updated list of users accordingly. If the delegate property is nil, then the method call will be ignored, and nothing will happen.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        // Indicates that there is only one section in the table view.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loggedInUsers.count
        // Corresponds to the number of rows in the table view.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // It is a required method for the UITableViewDataSource protocol. This method is responsible for creating and configuring a UITableViewCell object for a given indexPath (section and row).
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        // Dequeues a reusable UITableViewCell object from the table view with the identifier "UserCell" for the given indexPath. If there is no reusable cell available, the method creates a new UITableViewCell object.
        
        let user = loggedInUsers[indexPath.row]
        // Retrieves the corresponding User object from the loggedInUsers array based on the indexPath's row.
        
        cell.textLabel?.text = user.userName
        // Sets the text of the UITableViewCell's textLabel (if it exists) to the userName property of the User object.
        
        return cell
        // Returns the configured UITableViewCell object to be displayed in the table view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUpdatePassword" {
        // Checks if the segue's identifier is "showUpdatePassword".
            
            let updatePasswordVC = segue.destination as! UpdatePasswordViewController
            // Safely casts the destination view controller of the segue to an UpdatePasswordViewController object.
            
            updatePasswordVC.loggedInUsers = loggedInUsers
            // Passes the loggedInUsers array from the current view controller to the UpdatePasswordViewController.
            
            updatePasswordVC.lastLoggedInUserIndex = loggedInUsers.count - 1
            // Sets the lastLoggedInUserIndex property in the UpdatePasswordViewController to the index of the last logged-in user.
            // The loggedInUsers array contains a list of logged-in users. By subtracting 1 from the count, we obtain the index of the last element in the array. So, the index of the last element in the array will be count - 1.
            // After calculating the index of the last element in the loggedInUsers array, we assign that value to the lastLoggedInUserIndex property of the updatePasswordVC object, which is an instance of UpdatePasswordViewController.
            
            updatePasswordVC.delegate = loginViewControllerDelegate
            // When the user updates their password, the UpdatePasswordViewController will call the delegate method didUpdateUserPassword(_ user: User) on its delegate, which in this case is the loginViewControllerDelegate. This allows the delegate object (the object conforming to the UpdatePasswordViewControllerDelegate protocol) to respond to the password update event and take appropriate action, such as updating the user's password in its own data model or user interface.
        }
    }
}

extension ListOfUsersAfterLoginTableViewController: UpdatePasswordViewControllerDelegate {
    
    func didUpdateUserPassword(_ user: User) {
        if let index = loggedInUsers.firstIndex(where: { $0.userName == user.userName }) {
        // Uses the firstIndex(where:) method to find the index of the first user object in the users array whose userName property matches the userName of the passed-in user object.
            
            loggedInUsers[index] = user
            // Updates the users array at the found index with the updated user object. This effectively replaces the old user object with the updated one, which contains the new password.
            
            delegate?.updateLoggedInUsers(loggedInUsers)
            // It is checking if a delegate exists and then calling the updateLoggedInUsers method on that delegate to notify it about the updated list of logged-in users, providing the delegate with the necessary data to update its data model or user interface accordingly.
        }
    }
}
