//
//  MultiChoiceVC.swift
//  DeuQuiz
//
//  Created by Ferhat Kortak on 14.06.2020.
//  Copyright © 2020 og. All rights reserved.
//

import UIKit
import Firebase

class MultiChoiceVC: UIViewController {

    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var option4: UIButton!

    @IBOutlet weak var txtQuestion: UITextView!

    @IBOutlet weak var txtOption1: UITextField!
    @IBOutlet weak var txtOption2: UITextField!
    @IBOutlet weak var txtOption4: UITextField!
    @IBOutlet weak var txtOpt3: UITextField!

    @IBOutlet weak var questionCounter: UILabel!

    @IBOutlet weak var saveAndNextButton: UIButton!
    @IBOutlet weak var finishQuizButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpElement()
        questionCounter.text = String(QuizEntity.getInstance().questions.count + 1)
    }

    func clearCheckBoxes() {
        option1.isSelected = false
        option2.isSelected = false
        option3.isSelected = false
        option4.isSelected = false
    }

    @IBAction func nextQuestionTap(_ sender: Any) {

        saveQuestion()
    }

    func saveQuestion() {

        if !isInputProper() {
            // create the alert
            let alert = UIAlertController(title: "Warning!", message: "Please fill the inputs properly.", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        } else {

            var correctOption = ""

            if option1.isSelected {
                correctOption += "1|"
            }

            if option2.isSelected {
                correctOption += "2|"
            }

            if option3.isSelected {
                correctOption += "3|"
            }

            if option4.isSelected {
                correctOption += "4"
            }

            QuizEntity.addNewQuestion(
                    order: Int(questionCounter.text!)!,
                    option1: txtOption1.text!,
                    option2: txtOption2.text!,
                    option3: txtOpt3.text!,
                    option4: txtOption4.text!,
                    correct: correctOption,
                    questionText: txtQuestion.text,
                    type: "M"
            )

            clearInputs()
            clearCheckBoxes()

            increaseQuestionCounter()
        }
    }

    func clearInputs() {
        txtQuestion.text = ""
        txtOption1.text = ""
        txtOption2.text = ""
        txtOpt3.text = ""
        txtOption4.text = ""
    }

    func isInputProper() -> Bool {
        return txtOption1.text!.count > 0 && txtOption2.text!.count > 0 && txtOpt3.text!.count > 0 && txtOption4.text!.count > 0 && txtQuestion.text!.count > 0
    }

    func increaseQuestionCounter() {
        let x = Int(questionCounter.text!)! + 1
        questionCounter.text = String(x)
    }

    @IBAction func finishQuiz(_ sender: Any) {

        if isInputProper() {

            // First, save the current question, if it is proper.
            saveQuestion()


            let db = Firestore.firestore()
            let myQuizRef = db.collection("quiz").document(QuizEntity.getInstance().enterCode)

            QuizEntity.getInstance().createdDate = Date(timeIntervalSince1970: Date().timeIntervalSince1970)

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
                let questiosRef = myQuizRef.collection("questions")


                questiosRef.addDocument(data: [
                    "correct": question.correctAnswer,
                    "option1": question.option1,
                    "option2": question.option2,
                    "option3": question.option3,
                    "option4": question.option4,
                    "question": question.questionText,
                    "order": question.order,
                    "type": question.type
                ]) { err in
                    if let err = err {
                        print("Error adding question data to questios: \(err)")
                    }
                }
                print("added to question")
                index += 1
            }
        } else {
            // create the alert
            let alert = UIAlertController(title: "Warning!", message: "Please fill the inputs properly.", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }


        let homeViewController = self.storyboard?.instantiateViewController(identifier: "THomeVC") as? THomeViewController
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    }


    @IBAction func checkBoxSwitch(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }

    func setUpElement() {
        // Style the elements
        Utilities.styleFilledButton(saveAndNextButton)
        Utilities.styleHollowButton(finishQuizButton)
    }
}
