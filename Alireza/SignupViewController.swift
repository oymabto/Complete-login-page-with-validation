//
//  SignupViewController.swift
//  Alireza
//
//  Created by Alireza on 2023-03-15.
//

import UIKit

protocol SignupViewControllerDelegate: AnyObject {
    // Declares a protocol called SignupViewControllerDelegate that can be adopted by any class.
    
    func didRegisterUser(_ user: User)
    // Takes a single parameter of type User.
}

class SignupViewController: UIViewController {
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNmaeTF: UITextField!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordConfirmationTF: UITextField!
    @IBOutlet weak var questionTF: UITextField!
    @IBOutlet weak var answerTF: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    var users = [User]()
    // Declares a property called users, which is an array of User objects, and initializes it as an empty array.
    
    weak var delegate: SignupViewControllerDelegate?
    // Declares an optional weak delegate property of type SignupViewControllerDelegate?. The delegate will be used to communicate events, such as user registration, back to another view controller.
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        guard let password = passwordTF.text, let confirmPassword = passwordConfirmationTF.text, password == confirmPassword else {
            print("The passwords should be the same!")
            let alertController = UIAlertController(title: "SignUp Failed", message: "\nSorry, the password confirmation is incorrect. Please try again.", preferredStyle: .alert)
            // Initializes a new UIAlertController object, which is used to display alerts to the user. The title, message, and preferredStyle are set with the given values.
            
            alertController.addAction(UIAlertAction(title: "Ok! 🙈", style: .default, handler: { [weak self] _ in
                self?.passwordConfirmationTF.becomeFirstResponder()
            }))
            // Adds an action to the alertController. The UIAlertAction is initialized with the title "OK", a default style, and a handler.
            // The closer after handler gets executed when the action button is tapped. The closure takes one parameter, which is the UIAlertAction itself, represented by the _ placeholder.
            // The closure captures a weak reference to self (the UpdatePasswordViewController) to avoid a strong reference cycle.
            // [weak self] creates a weak reference to self within the closure. By doing this, you avoid a strong reference cycle between the closure and the UpdatePasswordViewController instance. If the closure were to capture a strong reference to self, it could potentially cause a memory leak if the UpdatePasswordViewController instance is deallocated while the closure is still holding a strong reference.
            
            self.present(alertController, animated: true, completion: nil)
            // This line presents the alertController on the screen. The animated: true parameter indicates that the presentation should be animated, while the completion: nil parameter indicates that no specific action should be performed after the presentation completes.
            return
        }
        
        guard let userName = userNameTF.text, !users.contains(where: { $0.userName == userName }) else {
            print("The username is already taken!")
            let alertController = UIAlertController(title: "SignUp Failed", message: "\nSorry, username is already taken. Please choose another user name!", preferredStyle: .alert)
            // Initializes a new UIAlertController object, which is used to display alerts to the user. The title, message, and preferredStyle are set with the given values.
            
            alertController.addAction(UIAlertAction(title: "Ok! 🙈", style: .default, handler: { [weak self] _ in
                self?.userNameTF.becomeFirstResponder()
            }))
            // Adds an action to the alertController. The UIAlertAction is initialized with the title "OK", a default style, and a handler.
            // The closer after handler gets executed when the action button is tapped. The closure takes one parameter, which is the UIAlertAction itself, represented by the _ placeholder.
            // The closure captures a weak reference to self (the UpdatePasswordViewController) to avoid a strong reference cycle.
            // [weak self] creates a weak reference to self within the closure. By doing this, you avoid a strong reference cycle between the closure and the UpdatePasswordViewController instance. If the closure were to capture a strong reference to self, it could potentially cause a memory leak if the UpdatePasswordViewController instance is deallocated while the closure is still holding a strong reference.
            
            self.present(alertController, animated: true, completion: nil)
            // This line presents the alertController on the screen. The animated: true parameter indicates that the presentation should be animated, while the completion: nil parameter indicates that no specific action should be performed after the presentation completes.

            return
        }
        
        let user = User(firstName: firstNameTF.text!,
                        lastName: lastNmaeTF.text!,
                        userName: userNameTF.text!,
                        password: password,
                        question: questionTF.text!,
                        answer: answerTF.text!)
        
        delegate?.didRegisterUser(user)
        // Calls the didRegisterUser method on the delegate, passing in the newly created user object.
        // The ? after delegate is used to safely unwrap the optional value.
        // If the delegate property contains a non-nil value, the didRegisterUser(_:) method will be called, passing the user object as an argument. If the delegate property is nil, the method call will be safely ignored.
        
        navigationController?.popViewController(animated: true)
        // Pops the current view controller from the navigation stack, returning the user to the previous view controller.
        // It is responsible for dismissing the current view controller (SignupViewController) and returning to the previous view controller in the navigation stack.
        // The navigationController property is an optional property of type UINavigationController?, and it holds a reference to the navigation controller that manages the view controller hierarchy.
        // "animated" parameter set to true. This means that the transition back to the previous view controller will be animated.
    }
    
}
