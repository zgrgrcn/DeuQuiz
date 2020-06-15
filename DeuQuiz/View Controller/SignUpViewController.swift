//
//  SignUpViewController.swift
//  DeuQuiz
//
//  Created by admin on 11.03.2020.
//  Copyright © 2020 og. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {


    @IBOutlet weak var studentNumberTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    var studentNumber = "111"
    var email = "aaa@aaa.com"
    var password = "***"

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
    }

    func setUpElements() {
        errorLabel.alpha = 0 // hide initial error label

        // Style the elements
        Utilities.styleTextField(studentNumberTextField)
        Utilities.styleTextField(emailAddressTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }

    @IBAction func signUpTapped(_ sender: Any) {

        //0-prepare fields
        studentNumber = (studentNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        email = (emailAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        password = (passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!

        //1-Validate the fields
        let error = validateFields()
        if error != nil {
            //There@s something wrong with the fields, Show error message
            showError(error!)
        } else {
            //2-Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //2.1-Check for error
                if (err != nil) {
                    //There was an error creating user
                    self.showError(err!.localizedDescription)
                } else {
                    //User was created successfully, now store the student number and mail
                    let db = Firestore.firestore()
                    db.collection("students").addDocument(data: [
                        "studentNumber": self.studentNumber,
                        "uid": result!.user.uid,
                        "email": self.email,
                        "pw": self.password
                    ]) { err in
                        if let err = err {
                            self.showError("Error adding document: \(err)")
                        }
                    }
                    //3-Transition to the home screen
//                    self.transitionToHome()
                }
            }

        }

    }

    //HELPER FUNCTIONS//

    //check the fields and validate that the data is correct. If everything is correct returns nil. Otherwise returs the error message as a string
    func validateFields() -> String? {
        //1.1-Check that all fields are filled in
        if studentNumber == "" ||
                   email == "" ||
                   password == "" {
            return "Please fill in all fields."
        }
        //1.2-Check if the password is secure
//            let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //        if !Utilities.isPasswordValid(password){
        //            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        //        }
        return nil
    }

    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.ShomeViewController) as? SHomeViewController

        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()

    }

    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
}
