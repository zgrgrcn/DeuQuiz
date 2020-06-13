//
//  LoginViewController.swift
//  DeuQuiz
//
//  Created by admin on 11.03.2020.
//  Copyright © 2020 og. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    var email="aaa@aaa.com"
    var password="***"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElement()
    }

    

    func setUpElement() {
        errorLabel.alpha = 0 // hide initial error label
        
        // Style the elements
        Utilities.styleTextField(emailAddressTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        //0-take text fields
        email=(emailAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        password=(passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        
        //1-validate text fields
        let error=validateFields()
        if error != nil{
            //There@s something wrong with the fields, Show error message
            showError(error!)
        }else{
            //2-goto database end take user
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, err in
                guard let strongSelf = self else { return }
                //check if error
                if let err=err{
                    self?.showError(err.localizedDescription)
                }else{
                    //user loged successfully
                    let mail=user?.user.email
                    if (mail!.contains("@hoca.com")) {
                        strongSelf.transitionToHome(type: "teacher")
                    }else {
                        strongSelf.transitionToHome(type: "student")
                    }
                }
            }
        }
    }
    
    //HELPER FUNCTIONS//
    
    //check the fields and validate that the data is correct. If everything is correct returns nil. Otherwise returs the error message as a string
    func validateFields()-> String?{
        //1.1-Check that all fields are filled in
        if  email == "" ||
            password == ""  {
            return "Please fill in all fields."
        }
        return nil
    }
    func transitionToHome(type:String){
        if(type=="student"){
            let homeViewController = self.storyboard?.instantiateViewController(identifier: "SHomeVC") as? SHomeViewController
            self.view.window?.rootViewController = homeViewController
            self.view.window?.makeKeyAndVisible()
        }
        else if(type=="teacher"){
            let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.ThomeViewController) as? THomeViewController
            self.view.window?.rootViewController = homeViewController
            self.view.window?.makeKeyAndVisible()
        }
        
    }
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
}
