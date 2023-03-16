//
//  ForgetPasswordViewController.swift
//  Alireza
//
//  Created by Alireza on 2023-03-15.
//

import UIKit 

protocol ForgetPasswordViewControllerDelegate: AnyObject {
// Declares a protocol named ForgetPasswordViewControllerDelegate that can only be adopted by class types.
    
    func didUpdateUserPassword(_ user: User)
    // Defines a required method called didUpdateUserPassword(_:) that takes a User object as an argument.
}

class ForgetPasswordViewController: UIViewController {
    
    @IBOutlet weak var answerTF: UITextField!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordConfirmationTF: UITextField!
    
    @IBOutlet weak var updateButton: UIButton!
    
    var users = [User]()
    // Declares a property named users, which is an array of User objects, initialized to an empty array.
    
    weak var delegate: ForgetPasswordViewControllerDelegate?
    // Declares an optional weak property named delegate of type ForgetPasswordViewControllerDelegate?. This property will be used to communicate with the object that implements the ForgetPasswordViewControllerDelegate protocol.
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func updateButtonPressed(_ sender: UIButton) {
        guard let userName = userNameTF.text,
              let user = users.first(where: { $0.userName == userName }),
              // Finds the first user object in the users array where the userName property of the user object matches the entered userName. If such a user is found, it is assigned to the constant user.
              
              let answer = answerTF.text, user.answer == answer,
              let password = passwordTF.text,
              let confirmPassword = passwordConfirmationTF.text, password == confirmPassword else {
            print ("Please enter the correct answer and user name!")
            let alertController = UIAlertController(title: "Password update Failed!", message: "\nSorry, the password confirmation is incorrect. Please try again.", preferredStyle: .alert)
            // Initializes a new UIAlertController object, which is used to display alerts to the user. The title, message, and preferredStyle are set with the given values.
            
            alertController.addAction(UIAlertAction(title: "Ok! 🙈", style: .default, handler: nil))
            // Adds an action to the alertController. The UIAlertAction is initialized with the title "OK", a default style, and a nil handler, meaning no specific action is performed when the button is tapped, other than dismissing the alert.
            
            self.present(alertController, animated: true, completion: nil)
            // This line presents the alertController on the screen. The animated: true parameter indicates that the presentation should be animated, while the completion: nil parameter indicates that no specific action should be performed after the presentation completes.
            return
        }
        
        var updatedUser = user
        // Creates a mutable copy of the user object and assigns it to the variable updatedUser.
        
        updatedUser.password = password
        // Updates the password property of the updatedUser object with the new password entered by the user.
        
        delegate?.didUpdateUserPassword(updatedUser)
        // Calls the didUpdateUserPassword(_:) method on the delegate, passing the updatedUser object as an argument.
        
        navigationController?.popViewController(animated: true)
        // Pops the current view controller from the navigation stack, returning the user to the previous view controller.
        // It is responsible for dismissing the current view controller (SignupViewController) and returning to the previous view controller in the navigation stack.
        // The navigationController property is an optional property of type UINavigationController?, and it holds a reference to the navigation controller that manages the view controller hierarchy.
        // "animated" parameter set to true. This means that the transition back to the previous view controller will be animated.
    }
    
}
