//
//  TestViewController.swift
//  DeuQuiz
//
//  Created by Ferhat Kortak on 13.06.2020.
//  Copyright © 2020 og. All rights reserved.
//

import UIKit
import Firebase

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

    @IBOutlet weak var questionCounter: UILabel!

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

    func clearRadioButtons() {
        radioButton1.isSelected = false
        radioButton2.isSelected = false
        radioButton3.isSelected = false
        radioButton4.isSelected = false
    }

    @IBAction func nextQuestionTap(_ sender: Any) {

        let isInputsProper = txtOption1.text!.count > 0 && txtOption2.text!.count > 0 && txtOption3.text!.count > 0 && txtOption4.text!.count > 0 && txtQuestion.text!.count > 0

        if !isInputsProper {
            // create the alert
            let alert = UIAlertController(title: "Warning!", message: "Please fill the inputs properly.", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        } else {

            var correctOption = "1"

            if radioButton1.isSelected {
                correctOption = "1"
            } else if radioButton2.isSelected {
                correctOption = "2"
            } else if radioButton3.isSelected {
                correctOption = "3"
            } else if radioButton4.isSelected {
                correctOption = "4"
            }

            QuizEntity.addNewQuestion(order: Int(questionCounter.text!)!,option1: txtOption1.text!, option2: txtOption2.text!, option3: txtOption3.text!, option4: txtOption4.text!, correct: correctOption, questionText: txtQuestion.text)

            var entity = QuizEntity.getInstance().questions

            txtQuestion.text = ""
            txtOption1.text = ""
            txtOption2.text = ""
            txtOption3.text = ""
            txtOption4.text = ""

            clearRadioButtons()
            radioButton1.isSelected = true

            increaseQuestionCounter()
        }
    }

    func increaseQuestionCounter() {
        let x = Int(questionCounter.text!)! + 1
        questionCounter.text = String(x)
    }

    @IBAction func finishQuiz(_ sender: Any) {
        QuizEntity.getInstance()

        let db = Firestore.firestore()
        let myQuizRef = db.collection("quiz").document(QuizEntity.getInstance().enterCode)

        QuizEntity.getInstance().createdDate=Date(timeIntervalSince1970: Date().timeIntervalSince1970)

        myQuizRef.setData([
            "createdDate": QuizEntity.getInstance().createdDate,
            "duration": QuizEntity.getInstance().duration,
            "isDone": "False",
            "quizName": QuizEntity.getInstance().title,
            "teacherID": QuizEntity.getInstance().teacherID
        ]) { err in
            if let err = err {
                print("Error creating quiz: \(err)")
            } else {
                print("Quiz successfully created!")
            }
        }


        var index = 0
        for question in QuizEntity.getInstance().questions {
            let questiosRef = myQuizRef.collection("questios")


            questiosRef.addDocument(data: [
                "correct": question.correctAnswer,
                "option1": question.option1,
                "option2": question.option2,
                "option3": question.option3,
                "option4": question.option4,
                "question": question.questionText,
                "order": question.order
            ]) { err in
                if let err = err {
                    print("Error adding question data to questios: \(err)")
                }
            }
            print("added to question")
            index += 1
        }
    }


}
