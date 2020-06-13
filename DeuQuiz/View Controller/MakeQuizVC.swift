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
    
    @IBAction func radioButtonSwitch(_ sender: UIButton) {
        
        radioButton1.isSelected = false
        radioButton2.isSelected = false
        radioButton3.isSelected = false
        radioButton4.isSelected = false
        
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
    
}
