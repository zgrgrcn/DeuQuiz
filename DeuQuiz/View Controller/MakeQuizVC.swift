//
//  TestViewController.swift
//  DeuQuiz
//
//  Created by Ferhat Kortak on 13.06.2020.
//  Copyright © 2020 og. All rights reserved.
//

import UIKit

class MakeQuizVC: UIViewController {
    @IBOutlet weak var radioButton1: UIButton!
    @IBOutlet weak var radioButton2: UIButton!
    @IBOutlet weak var radioButton3: UIButton!
    @IBOutlet weak var radioButton4: UIButton!
    
    @IBOutlet weak var txtQuestion: UITextView!
    
    @IBOutlet weak var txtOption1: UITextField!
    @IBOutlet weak var txtOption2: UITextField!
    @IBOutlet weak var txtOption3: UITextField!
    @IBOutlet weak var txtOption4: UITextField!
    
    override func viewDidLoad() {
        radioButton1.isSelected = true
    }
    
    @IBAction func radioButtonSwitch(_ sender: UIButton) {
        
        clearRadioButtons()
        
        switch sender.tag {
            case 1:
                radioButton1.isSelected = true
            case 2:
                radioButton2.isSelected = true
            case 3:
                radioButton3.isSelected = true
            case 4:
                radioButton4.isSelected = true
        default:
            print("An error has occured")
        }
    }
    
    func clearRadioButtons(){
        radioButton1.isSelected = false
        radioButton2.isSelected = false
        radioButton3.isSelected = false
        radioButton4.isSelected = false
    }
    
    @IBAction func nextQuestionTap(_ sender: Any) {
        
        txtQuestion.text = ""
        txtOption1.text = ""
        txtOption2.text = ""
        txtOption3.text = ""
        txtOption4.text = ""
        
        clearRadioButtons()
        radioButton1.isSelected = true
    }
}
