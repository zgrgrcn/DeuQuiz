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
//    public static var quiz = QuizEntity.sharedInstance

    @IBOutlet weak var quizTitle: UITextField!
    @IBOutlet weak var duration: UITextField!
    @IBOutlet weak var enterCode: UITextField!

    override func viewDidLoad() {

    }

    @IBAction func btnMakeQuiz(_ sender: Any) {


        let isProperInput = quizTitle.text!.count > 2 && duration.text!.count > 0 && enterCode.text?.count == 6

        if !isProperInput {

            // create the alert
            let alert = UIAlertController(title: "Warning!", message: "Please fill the inputs properly.", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)

        } else {
            var title = quizTitle.text;
            var totalDuration = Int(duration.text!) ?? 10;
            var code = enterCode.text;
            var userID = Auth.auth().currentUser?.uid

            // Fill the entity
            QuizEntity.getInstance().title = title!
            QuizEntity.getInstance().duration = totalDuration
            QuizEntity.getInstance().enterCode = code!
            QuizEntity.getInstance().teacherID = userID!
        }
    }

}
