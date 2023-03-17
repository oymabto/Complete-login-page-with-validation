//
//  LoginViewController.swift
//  Alireza
//
//  Created by Alireza on 2023-03-15.
//

import UIKit

class LoginViewController: UIViewController {
    // Defines a new class named LoginViewController that inherits from UIViewController.
    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    var users = [User]()
    // Defines an array to store User objects representing all registered users.
    
    var loggedInUsers = [User]()
    // Defines an array to store User objects representing users who have successfully logged in.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeModel()
        // It is called to set up the initial data which is an array of registered users.
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        // This method is called when the "Sign Up" button is tapped.
        
        print("The Sign Up button is pressed!")
        // Checking (for developer use only)
        
        performSegue(withIdentifier: "showSignup", sender: nil)
        // It triggers a segue to the signup view controller.
    }
    
    @IBAction func forgetPasswordButtonTapped(_ sender: Any) {
        // This method is called when the "Forget Password" button is tapped.
        
        print ("The Forget Password button is pressed!")
        // Checking (for developer use only)
        
        performSegue(withIdentifier: "showForgetPassword", sender: nil)
        // It triggers a segue to the forget password view controller.
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        // This method is called when the "Login" button is tapped.
        
        guard let username = userNameTF.text, let password = passwordTF.text else { return }
        // Checks the entered username and password against the registered users.
        
        for user in users {
        // Iterates through each element in the users array.
            
            if user.userName == username && user.password == password {
            // If the user is found and the password is correct, a segue to the list of users table view controller is triggered and immediately exits the loop and the enclosing function.
                
                print ("The user name and password are correct.")
                // Checking (for developer use only)
                
                performSegue(withIdentifier: "showListOfUsers", sender: sender)
                // It triggers a segue to the table view controller and passing the sender parameter along.
                
                return
            }
        }
        
        print ("Incorrect username or password.")
        // Checking (for developer use only)
        
        let alertController = UIAlertController(title: "Login Failed", message: "\nSorry, incorrect username or password. Please try again.", preferredStyle: .alert)
        // Initializes a new UIAlertController object, which is used to display alerts to the user. The title, message, and preferredStyle are set with the given values.
        
        alertController.addAction(UIAlertAction(title: "Try again. 🙂", style: .default, handler: nil))
        // Adds an action to the alertController. The UIAlertAction is initialized with the title "OK", a default style, and a nil handler, meaning no specific action is performed when the button is tapped, other than dismissing the alert.
        
        self.present(alertController, animated: true, completion: nil)
        // This line presents the alertController on the screen. The animated: true parameter indicates that the presentation should be animated, while the completion: nil parameter indicates that no specific action should be performed after the presentation completes.
    }
    
    @IBAction func unwindToLoginVC(_ unwindSegue: UIStoryboardSegue) {
        // This method is called when an unwind segue is performed from another view controller to return to the LoginViewController.
        
        if let sourceViewController = unwindSegue.source as? ListOfUsersAfterLoginTableViewController {
            // The unwindSegue parameter is a UIStoryboardSegue object representing the segue being performed.
            // The source property represents the view controller initiating the unwind segue.
            
            loggedInUsers = sourceViewController.loggedInUsers
            // Updates the loggedInUsers array based on the source view controller's data.
            // This is done to keep the data synchronized between the two view controllers.
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // It is called just before performing a segue. It sets up the destination view controller's properties and delegates as needed based on the identifier of the segue being performed.
        // The override keyword indicates that this method is overriding a method with the same signature in its superclass (UIViewController).
        // The "segue" parameter is a UIStoryboardSegue object representing the segue being performed.
        // The "sender" parameter is an optional value that can be used to pass additional information to the destination view controller.
        
        if segue.identifier == "showSignup", let signupVC = segue.destination as? SignupViewController {
        // Checks if the segue's identifier is equal to "showSignup" and safely casts the destination property of the segue object to a SignupViewController.
            
            signupVC.users = users
            // Sets the users property of the destination view controller (signupVC) to the current users array
            
            signupVC.delegate = self
            // Assigns the LoginViewController instance (self) as its delegate.
            
        } else if segue.identifier == "showForgetPassword", let forgetPasswordVC = segue.destination as? ForgetPasswordViewController {
            // Checks if the segue's identifier is equal to "showForgetPassword" and safely casts the destination property of the segue object to a ForgetPasswordViewController
            
            forgetPasswordVC.users = users
            // Assigns the users array from the LoginViewController to the users property of the ForgetPasswordViewController
            
            forgetPasswordVC.delegate = self
            // Assigns the LoginViewController as the delegate of the ForgetPasswordViewController. This allows the LoginViewController to receive callbacks from the ForgetPasswordViewController, such as when a user's password is updated.
            // This line is used to set up a communication channel between the two view controllers, allowing the LoginViewController to receive callbacks from the ForgetPasswordViewController.
            
        } else if segue.identifier == "showListOfUsers", let destinationVC = segue.destination as? ListOfUsersAfterLoginTableViewController, let username = userNameTF.text, let password = passwordTF.text {
            // Checks if the segue identifier is "showListOfUsers", if the destination view controller can be safely cast as a ListOfUsersAfterLoginTableViewController, and if the userNameTF and passwordTF text fields have non-nil text values.
            destinationVC.loginViewControllerDelegate = self
            
            for user in users {
            // Iterates through the users array.
                
                if user.userName == username && user.password == password {
                // Checks if the current user object in the loop has a matching userName and password as the entered text values from the text fields
                    
                    if !loggedInUsers.contains(where: { $0.userName == user.userName }) {
                    // Checks if the loggedInUsers array does not already contain a user with the same userName as the current user object.
                        
                        loggedInUsers.append(user)
                        // Append the user to the loggedInUsers array
                    }
                    break
                }
            }
            destinationVC.loggedInUsers = loggedInUsers
            // Sets the loggedInUsers property of the destinationVC to the value of the loggedInUsers property of the LoginViewController.
            
            destinationVC.delegate = self
            // Sets the delegate property of the destinationVC to the LoginViewController.
            // By doing this, you're establishing a communication channel between the ListOfUsersAfterLoginTableViewController and the LoginViewController.
            // By setting the delegate property of the destinationVC to self, you're telling the ListOfUsersAfterLoginTableViewController that the LoginViewController is responsible for handling the tasks specified in the ListOfUsersAfterLoginTableViewControllerDelegate protocol. This enables the LoginViewController to receive callbacks from the ListOfUsersAfterLoginTableViewController and react to events that occur within that view controller, such as updating the list of logged-in users or handling user password changes.
        }
    }
        func initializeModel(){
            let user1 = User(firstName: "John",
                             lastName: "Abbot",
                             userName: "john",
                             password: "1234",
                             question: "Favorite pet?",
                             answer: "dog")
            let user2 = User(firstName: "Brendan",
                             lastName: "Fraser",
                             userName: "bfg",
                             password: "abcd",
                             question: "Occupation?",
                             answer: "actor")
            let user3 = User(firstName: "Michael",
                             lastName: "Jordan",
                             userName: "michael",
                             password: "abc123",
                             question: "Favorite sport?",
                             answer: "basketball")
            users = [user1, user2, user3]
        }
    }
    
    extension LoginViewController: SignupViewControllerDelegate, ForgetPasswordViewControllerDelegate, ListOfUsersAfterLoginTableViewControllerDelegate, UpdatePasswordViewControllerDelegate {
    // Conforms to three delegate protocols
    // This allows the LoginViewController to handle events and updates from these three view controllers.
        
        func didRegisterUser(_ user: User) {
        // Takes a User object as a parameter, representing the newly registered user.
            
            users.append(user)
            // Adds the newly registered user (passed as the user parameter) to the users array in the LoginViewController. This array stores all registered users.
        }
        
        func didUpdateUserPassword(_ user: User) {
            if let index = users.firstIndex(where: { $0.userName == user.userName }) {
            // Uses the firstIndex(where:) method to find the index of the first user object in the users array whose userName property matches the userName of the passed-in user object.
                
                users[index] = user
                // Updates the users array at the found index with the updated user object. This effectively replaces the old user object with the updated one, which contains the new password.
            }
        }
        
        func updateLoggedInUsers(_ loggedInUsers: [User]) {
            self.loggedInUsers = loggedInUsers
            // Assigns the value of the loggedInUsers parameter to the loggedInUsers property of the LoginViewController.
            // The self keyword is used to refer to the current instance of the LoginViewController.
            // By doing this assignment, the loggedInUsers property of the LoginViewController is updated with the new list of logged-in users passed to the function.
        }
        
    }
    
    
    
    
