//
//  ViewController.swift
//  DeuQuiz
//
//  Created by admin on 11.03.2020.
//  Copyright © 2020 og. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if Auth.auth().currentUser == nil {
          // User not sign in so show to user sign up an login buttons
            setUpElement()
        } else {
           // User is signed in.
            DispatchQueue.main.async{
                self.transitionToHome()
            }
        }

    }
    
    func transitionToHome(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let mail=Auth.auth().currentUser?.email
        
        if (mail!.contains("@hoca.com")) {
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "THomeVC") as! THomeViewController
            self.show(nextViewController, sender: nil)
        }else {
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SHomeVC") as! SHomeViewController
            self.show(nextViewController, sender: nil)
        }
    }
    func setUpElement() {
        // Style the elements
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
    }

}

