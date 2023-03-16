//
//  UpdatePasswordViewController.swift
//  Alireza
//
//  Created by Alireza on 2023-03-15.
//

import UIKit

protocol UpdatePasswordViewControllerDelegate: AnyObject {
// Declares a protocol named UpdatePasswordViewControllerDelegate that can only be implemented by classes (not structures or enums).
    
    func didUpdateUserPassword(_ user: User)
    // Defines a method in the protocol for informing the delegate when a user's password has been updated.
}

class UpdatePasswordViewController: UIViewController {
    
    @IBOutlet weak var oldPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTFConfirmation: UITextField!
    
    @IBOutlet weak var updateButton: UIButton!
    
    var lastLoggedInUserIndex: Int!
    // Stores the index of the last logged-in user in the loggedInUsers array.
    
    var loggedInUsers: [User]!
    // Stores the logged-in users.
    
    weak var delegate: UpdatePasswordViewControllerDelegate?
    // The reference to the delegate is weak to avoid retain cycles.
    // A retain cycle occurs when two objects have strong references to each other, preventing them from being deallocated.
    // By making the reference to the delegate weak, you ensure that when the delegate object is no longer needed, it can be deallocated even if the UpdatePasswordViewController is still holding a reference to it.
    
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
            if loggedInUsers?[lastLoggedInUserIndex].password != oldPasswordTF.text{
                print("Incorrect old password.")
                let alertController = UIAlertController(title: "Change password Failed", message: "\nSorry, the old password is incorrect. Please try again!", preferredStyle: .alert)
                // Initializes a new UIAlertController object, which is used to display alerts to the user. The title, message, and preferredStyle are set with the given values.
                
                alertController.addAction(UIAlertAction(title: "Try again. 😞", style: .default, handler: { [weak self] _ in
                            self?.oldPasswordTF.becomeFirstResponder()
                        }))
                // Adds an action to the alertController. The UIAlertAction is initialized with the title "OK", a default style, and a handler.
                // The closer after handler gets executed when the action button is tapped. The closure takes one parameter, which is the UIAlertAction itself, represented by the _ placeholder.
                // The closure captures a weak reference to self (the UpdatePasswordViewController) to avoid a strong reference cycle.
                // [weak self] creates a weak reference to self within the closure. By doing this, you avoid a strong reference cycle between the closure and the UpdatePasswordViewController instance. If the closure were to capture a strong reference to self, it could potentially cause a memory leak if the UpdatePasswordViewController instance is deallocated while the closure is still holding a strong reference.
                // self?.oldPasswordTF.becomeFirstResponder() is executed when the "Try again. 😞" button is tapped. It calls the becomeFirstResponder() method on the oldPasswordTF property of the UpdatePasswordViewController.
                // The becomeFirstResponder() method makes the oldPasswordTF (a UITextField instance) the first responder, which means it will receive user input, such as keyboard events. In practical terms, this line of code will cause the keyboard to appear and the oldPasswordTF text field to become active and highlighted when the user taps the "Try again. 😞" button.
                
                self.present(alertController, animated: true, completion: nil)
                // This line presents the alertController on the screen. The animated: true parameter indicates that the presentation should be animated, while the completion: nil parameter indicates that no specific action should be performed after the presentation completes.
            } else {
                print("New password does not match.")
                let alertController = UIAlertController(title: "Change password Failed", message: "\nSorry, the password confirmation is incorrect. Please try again!", preferredStyle: .alert)
                // Initializes a new UIAlertController object, which is used to display alerts to the user. The title, message, and preferredStyle are set with the given values.
                
                alertController.addAction(UIAlertAction(title: "Try again. 😞", style: .default, handler: { [weak self] _ in
                            self?.newPasswordTFConfirmation.becomeFirstResponder()
                        }))
                // Adds an action to the alertController. The UIAlertAction is initialized with the title "OK", a default style, and a nil handler, meaning no specific action is performed when the button is tapped, other than dismissing the alert.
                
                self.present(alertController, animated: true, completion: nil)
                // This line presents the alertController on the screen. The animated: true parameter indicates that the presentation should be animated, while the completion: nil parameter indicates that no specific action should be performed after the presentation completes.
            }
            
            return
        }
        var updatedUser = user
        // Creates a mutable copy of the user object and assigns it to the variable updatedUser.

        updatedUser.password = newPassword
        // Updates the password property of the updatedUser object with the new password entered by the user.

        delegate?.didUpdateUserPassword(updatedUser)
        // Calls the didUpdateUserPassword(_:) method on the delegate, passing the updatedUser object as an argument.

        navigationController?.popToRootViewController(animated: true)
        // Pops the current view controller from the navigation stack, returning the user to the previous view controller.
        // It is responsible for dismissing the current view controller (SignupViewController) and returning to the previous view controller in the navigation stack.
        // The navigationController property is an optional property of type UINavigationController?, and it holds a reference to the navigation controller that manages the view controller hierarchy.
        // "animated" parameter set to true. This means that the transition back to the previous view controller will be animated.
    }
}
