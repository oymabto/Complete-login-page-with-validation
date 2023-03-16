//
//  ListOfUsersAfterLoginTableViewController.swift
//  Alireza
//
//  Created by Alireza on 2023-03-15.
//

import UIKit

protocol ListOfUsersAfterLoginTableViewControllerDelegate: AnyObject {
    func updateLoggedInUsers(_ loggedInUsers: [User])
}

class ListOfUsersAfterLoginTableViewController: UITableViewController {
    
    var loggedInUsers: [User] = []
    weak var delegate: ListOfUsersAfterLoginTableViewControllerDelegate?
    weak var loginViewControllerDelegate: UpdatePasswordViewControllerDelegate?


    @IBOutlet weak var changePasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.updateLoggedInUsers(loggedInUsers)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loggedInUsers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let user = loggedInUsers[indexPath.row]
        cell.textLabel?.text = user.userName
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUpdatePassword" {
            let updatePasswordVC = segue.destination as! UpdatePasswordViewController
            updatePasswordVC.loggedInUsers = loggedInUsers
            updatePasswordVC.lastLoggedInUserIndex = loggedInUsers.count - 1
            updatePasswordVC.delegate = loginViewControllerDelegate
        }
    }

}

extension ListOfUsersAfterLoginTableViewController: UpdatePasswordViewControllerDelegate {
    func didUpdateUserPassword(_ user: User) {
        if let index = loggedInUsers.firstIndex(where: { $0.userName == user.userName }) {
            loggedInUsers[index] = user
            delegate?.updateLoggedInUsers(loggedInUsers)
        }
    }
}
