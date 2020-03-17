//
//  ViewController.swift
//  DeuQuiz
//
//  Created by admin on 11.03.2020.
//  Copyright © 2020 og. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElement()
    }

    func setUpElement() {
        // Style the elements
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
    }

}

