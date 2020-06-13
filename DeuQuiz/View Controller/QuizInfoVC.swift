//
//  QuizInfoVC.swift
//  DeuQuiz
//
//  Created by Ferhat Kortak on 13.06.2020.
//  Copyright © 2020 og. All rights reserved.
//

import UIKit
import Firebase

class QuizInfoVC: UIViewController {
    public static var quiz = QuizEntity()
    
    @IBOutlet weak var quizTitle: UITextField!
    @IBOutlet weak var duration: UITextField!
    @IBOutlet weak var enterCode: UITextField!
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func btnMakeQuiz(_ sender: Any) {
        var title = quizTitle.text;
        var totalDuration = Int(duration.text!) ?? 10;
        var code = enterCode.text;
        
        var userID = Auth.auth().currentUser?.uid
    }
    
}
