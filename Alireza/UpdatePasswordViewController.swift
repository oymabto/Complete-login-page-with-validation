//
//  UpdatePasswordViewController.swift
//  Alireza
//
//  Created by Alireza on 2023-03-15.
//

import UIKit

protocol UpdatePasswordViewControllerDelegate: AnyObject {
    func didUpdateUserPassword(_ user: User)
}

class UpdatePasswordViewController: UIViewController {
    
    @IBOutlet weak var oldPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTFConfirmation: UITextField!
    
    @IBOutlet weak var updateButton: UIButton!
    
    var lastLoggedInUserIndex: Int!
    var loggedInUsers: [User]!
    weak var delegate: UpdatePasswordViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func updateButtonPressed(_ sender: UIButton) {
        guard let oldPassword = oldPasswordTF.text,
              let newPassword = newPasswordTF.text,
              let newPasswordConfirmation = newPasswordTFConfirmation.text,
              newPassword == newPasswordConfirmation,
              loggedInUsers?[lastLoggedInUserIndex].password == oldPassword,
              let user = loggedInUsers?[lastLoggedInUserIndex] else {
            print("Incorrect old password.")
            let alertController = UIAlertController(title: "Change password Failed", message: "\nSorry, the password is incorrect. Please try again!", preferredStyle: .alert)
            // Initializes a new UIAlertController object, which is used to display alerts to the user. The title, message, and preferredStyle are set with the given values.
            
            alertController.addAction(UIAlertAction(title: "Try again. 😞", style: .default, handler: nil))
            // Adds an action to the alertController. The UIAlertAction is initialized with the title "OK", a default style, and a nil handler, meaning no specific action is performed when the button is tapped, other than dismissing the alert.
            
            self.present(alertController, animated: true, completion: nil)
            // This line presents the alertController on the screen. The animated: true parameter indicates that the presentation should be animated, while the completion: nil parameter indicates that no specific action should be performed after the presentation completes.
            return
        }
        var updatedUser = user
        updatedUser.password = newPassword
        delegate?.didUpdateUserPassword(updatedUser)
        navigationController?.popToRootViewController(animated: true)
    }
}
