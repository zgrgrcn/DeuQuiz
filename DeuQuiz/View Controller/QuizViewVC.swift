//
//  QuizViewVC.swift
//  DeuQuiz
//
//  Created by admin on 15.06.2020.
//  Copyright © 2020 og. All rights reserved.
//

import UIKit
import Firebase

class QuizViewVC: UIViewController {

    // general quiz info
    @IBOutlet weak var quizNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var orderLabel: UILabel!

    // question
    @IBOutlet weak var questionText: UITextView!

    // single and multi answer
    @IBOutlet weak var option1Text: UITextField!
    @IBOutlet weak var option2Text: UITextField!
    @IBOutlet weak var option3Text: UITextField!
    @IBOutlet weak var option4Text: UITextField!

    // single selection
    @IBOutlet weak var radioButton1: UIButton!
    @IBOutlet weak var radioButton2: UIButton!
    @IBOutlet weak var radioButton3: UIButton!
    @IBOutlet weak var radioButton4: UIButton!

    // multi selection
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var option4: UIButton!

    // true/false selection
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!

    // onceki/sonraki soru butonlari
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    var currentQuestionOrder = 1
    var currentPage = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        currentPage = getCurrentPageType()
        currentQuestionOrder = StudentAnswerEntity.getInstance().currentQuestionOrder
        if currentPage == "SingleQuizViewVC" {
            if StudentAnswerEntity.getInstance().answers.count > currentQuestionOrder {
                for answer in StudentAnswerEntity.getInstance().answers {
                    if answer.order==currentQuestionOrder {
                        radioButton1.isSelected = answer.studentAnswer.contains("1")
                        radioButton2.isSelected = answer.studentAnswer.contains("2")
                        radioButton3.isSelected = answer.studentAnswer.contains("3")
                        radioButton4.isSelected = answer.studentAnswer.contains("4")
                    }
                }
                //currentQuestionOrder ->1  //yani arrayin 2.elemani
            } else {
                radioButton1.isSelected = true
            }
            option1Text.text = QuizEntity.getInstance().questions[currentQuestionOrder].option1
            option2Text.text = QuizEntity.getInstance().questions[currentQuestionOrder].option2
            option3Text.text = QuizEntity.getInstance().questions[currentQuestionOrder].option3
            option4Text.text = QuizEntity.getInstance().questions[currentQuestionOrder].option4
        } else if currentPage == "TFQuizViewVC" {
            if StudentAnswerEntity.getInstance().answers.count > currentQuestionOrder {
                for answer in StudentAnswerEntity.getInstance().answers {
                    if answer.order==currentQuestionOrder {
                        trueButton.isSelected = answer.studentAnswer=="TRUE"
                        falseButton.isSelected = answer.studentAnswer=="FALSE"
                    }
                }
                //currentQuestionOrder ->1  //yani arrayin 2.elemani
            } else {
                trueButton.isSelected = true;
            }
        } else if currentPage == "MultiQuizViewVC" {
            if StudentAnswerEntity.getInstance().answers.count > currentQuestionOrder {
                for answer in StudentAnswerEntity.getInstance().answers {
                    if answer.order==currentQuestionOrder {
                        option1.isSelected = answer.studentAnswer.contains("1")
                        option2.isSelected = answer.studentAnswer.contains("2")
                        option3.isSelected = answer.studentAnswer.contains("3")
                        option4.isSelected = answer.studentAnswer.contains("4")
                    }
                }
                //currentQuestionOrder ->1  //yani arrayin 2.elemani
            } else {
                option1.isSelected = true;
            }
            option1Text.text = QuizEntity.getInstance().questions[currentQuestionOrder].option1
            option2Text.text = QuizEntity.getInstance().questions[currentQuestionOrder].option2
            option3Text.text = QuizEntity.getInstance().questions[currentQuestionOrder].option3
            option4Text.text = QuizEntity.getInstance().questions[currentQuestionOrder].option4
        }

        StudentAnswerEntity.getInstance().studentID = Auth.auth().currentUser!.uid
        StudentAnswerEntity.getInstance().quizID = QuizEntity.getInstance().enterCode
        quizNameLabel.text = QuizEntity.getInstance().title
        timeLabel.text = "Time: " + String(QuizEntity.getInstance().duration)
        orderLabel.text = String(QuizEntity.getInstance().questions[currentQuestionOrder].order) + "/"
        orderLabel.text! += String(QuizEntity.getInstance().questions.count)

        questionText.text = QuizEntity.getInstance().questions[currentQuestionOrder].questionText


        //ilk soru icin back tusunu kapat
        if currentQuestionOrder == 0 {
            backButton.isHidden = true
        } else {
            backButton.isHidden = false
        }

        //son soru icin next tusu yerine finish yap
        if currentQuestionOrder == QuizEntity.getInstance().questions.count-1 {
            nextButton.setTitle("Finish", for: .normal)
        } else {
            nextButton.setTitle("Next", for: .normal)
        }
    }

    @IBAction func prevQuestion(_ sender: Any) {
        addAnswer()
        StudentAnswerEntity.getInstance().currentQuestionOrder -= 1
        changeQuestion()
    }

    @IBAction func nextQuestion(_ sender: Any) {
        //get user's answer
        addAnswer()
        StudentAnswerEntity.getInstance().currentQuestionOrder += 1
        if StudentAnswerEntity.getInstance().currentQuestionOrder > QuizEntity.getInstance().questions.count-1 {
            finishQuizAndSendStudentAnswersToFireBase()
        } else {
            changeQuestion()
        }
    }

    private func finishQuizAndSendStudentAnswersToFireBase() {
        let db = Firestore.firestore()
        let myQuizRef = db.collection("quiz").document(QuizEntity.getInstance().enterCode)
        let participantRef = myQuizRef.collection("participants").document(StudentAnswerEntity.getInstance().studentID)


        //1- save this quiz to firebase@ participants
        //that answers collections=>studentID=>questionNumbers=>questionNumber

        var totalCorrect = 0
        var totalWrong = 0
        for answer in StudentAnswerEntity.getInstance().answers {//save each answer to db
            if answer.isCorrect {
                totalCorrect += 1
            } else {
                totalWrong += 1
            }
            let order = String(answer.order)
            participantRef.collection(StudentAnswerEntity.getInstance().studentID).document(order).setData([
                "studentAnswer": answer.studentAnswer,
                "correctAnswer": answer.correctAnswer,
                "questionText": answer.correctAnswer,
                "isCorrect": answer.isCorrect,
                "type": answer.type
            ]) { err in
                if let err = err {
                    print("Error adding student answers data to answer table: \(err)")
                }else {
                    print("added to student answers")
                }
            }
        }
        //2- save finish time and statics to firebase@ participants
        participantRef.updateData([
            "finishDate": Date(timeIntervalSince1970: Date().timeIntervalSince1970),
            "totalCorrect": totalCorrect,
            "totalWrong": totalWrong
        ]) { err in
            if let err = err {
                print("Error updating finishDate of participantRef document: \(err)")
            } else {
                print("FinishDate of participantRef document successfully updated")
            }
        }

        //3- save that user statics to that student db
        let myStudentRef = db.collection("students").document(StudentAnswerEntity.getInstance().studentID)

        myStudentRef.updateData([
            QuizEntity.getInstance().enterCode: String(totalCorrect)+"|"+String(totalWrong)

        ]) { err in
            if let err = err {
                print("Error adding user statics to student table: \(err)")
            }else {
                print("user statics added to student")
            }
        }

        //3- send user to SHomeView page
        let homeViewController = self.storyboard?.instantiateViewController(identifier: "SHomeVC") as? SHomeViewController
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    }

    private func addAnswer() {

        var studentAnswer = ""
        if QuizEntity.getInstance().questions[currentQuestionOrder].type == "TF" {

            studentAnswer = String(trueButton.isSelected).uppercased()

        } else if QuizEntity.getInstance().questions[currentQuestionOrder].type == "M" {

            if option1.isSelected {
                studentAnswer += "1|"
            }
            if option2.isSelected {
                studentAnswer += "2|"
            }
            if option3.isSelected {
                studentAnswer += "3|"
            }
            if option4.isSelected {
                studentAnswer += "4|"
            }

        } else if QuizEntity.getInstance().questions[currentQuestionOrder].type == "S" {

            if radioButton1.isSelected {
                studentAnswer = "1"
            }
            if radioButton2.isSelected {
                studentAnswer = "2"
            }
            if radioButton3.isSelected {
                studentAnswer = "3"
            }
            if radioButton4.isSelected {
                studentAnswer = "4"
            }

        } else {
            print("at QuizViewVC => addAnswer => question.type")
        }

        StudentAnswerEntity.addNewAnswer(
                order: currentQuestionOrder,
                studentAnswer: studentAnswer,
                correctAnswer: QuizEntity.getInstance().questions[currentQuestionOrder].correctAnswer,
                questionText: QuizEntity.getInstance().questions[currentQuestionOrder].questionText,
                type: QuizEntity.getInstance().questions[currentQuestionOrder].type
        )
    }

    private func changeQuestion() {
        currentQuestionOrder = StudentAnswerEntity.getInstance().currentQuestionOrder

        let target = getCurrentPageType()

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: target) as! QuizViewVC
        print(target)


        self.show(nextViewController, sender: nil)


    }

    func getCurrentPageType() -> String {
        currentQuestionOrder = StudentAnswerEntity.getInstance().currentQuestionOrder

        var currentType = "SingleQuizViewVC"

        if QuizEntity.getInstance().questions[currentQuestionOrder].type == "TF" {
            currentType = "TFQuizViewVC"
        } else if QuizEntity.getInstance().questions[currentQuestionOrder].type == "M" {
            currentType = "MultiQuizViewVC"
        }

        return currentType
    }

    @IBAction func trueFalseSwitch(_ sender: UIButton) {

        if getCurrentPageType() == "TFQuizViewVC" {

            trueButton.isSelected = false
            falseButton.isSelected = false

            sender.isSelected = true
        }
    }

    @IBAction func checkBoxVC(_ sender: UIButton) {
        if currentPage == "MultiQuizViewVC" {
            sender.isSelected = !sender.isSelected
        }
    }

    @IBAction func radioButtonSwitch(_ sender: UIButton) {
        if currentPage == "SingleQuizViewVC" {
            radioButton1.isSelected = false
            radioButton2.isSelected = false
            radioButton3.isSelected = false
            radioButton4.isSelected = false

            sender.isSelected = true
        }
    }


}
