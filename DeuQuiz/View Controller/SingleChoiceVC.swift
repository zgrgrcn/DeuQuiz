//
//  SingleChoiceVC.swift
//  DeuQuiz
//
//  Created by Ferhat Kortak on 14.06.2020.
//  Copyright © 2020 og. All rights reserved.
//

import UIKit
import Firebase

class SingleChoiceVC: UIViewController {

    @IBOutlet weak var radioButton1: UIButton!
    @IBOutlet weak var radioButton2: UIButton!

    @IBOutlet weak var txtQuestion: UITextView!

    @IBOutlet weak var questionCounter: UILabel!

    @IBOutlet weak var saveAndNextButton: UIButton!
    @IBOutlet weak var finishQuizButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpElement()
        radioButton1.isSelected = true
        questionCounter.text = String(QuizEntity.getInstance().questions.count + 1)
    }

    @IBAction func radioButtonSwitch(_ sender: UIButton) {

        clearRadioButtons()

        switch sender.tag {
        case 1:
            radioButton1.isSelected = true
        case 2:
            radioButton2.isSelected = true
        default:
            print("An error has occured")
        }
    }

    func clearRadioButtons() {
        radioButton1.isSelected = false
        radioButton2.isSelected = false
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

            var correctOption = "1"

            if radioButton1.isSelected {
                correctOption = "TRUE"
            } else if radioButton2.isSelected {
                correctOption = "FALSE"
            }

            QuizEntity.addNewQuestion(order: Int(questionCounter.text!)!,
                    option1: "",
                    option2: "",
                    option3: "",
                    option4: "",
                    correct: correctOption,
                    questionText: txtQuestion.text, type: "TF")

            clearInputs()
            clearRadioButtons()

            radioButton1.isSelected = true

            increaseQuestionCounter()
        }
    }

    func clearInputs() {
        txtQuestion.text = ""
    }

    func isInputProper() -> Bool {
        return txtQuestion.text!.count > 0
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
    }

    func setUpElement() {
        // Style the elements
        Utilities.styleFilledButton(saveAndNextButton)
        Utilities.styleHollowButton(finishQuizButton)
    }
}
