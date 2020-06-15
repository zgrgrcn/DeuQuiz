//
//  QuizViewVC.swift
//  DeuQuiz
//
//  Created by admin on 15.06.2020.
//  Copyright © 2020 og. All rights reserved.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
        currentQuestionOrder = StudentAnswerEntity.getInstance().currentQuestionOrder
        quizNameLabel.text = QuizEntity.getInstance().title
        timeLabel.text = "Time: " + String(QuizEntity.getInstance().duration)
        orderLabel.text = String(QuizEntity.getInstance().questions[currentQuestionOrder - 1].order) + "/"
        orderLabel.text! += String(QuizEntity.getInstance().questions.count)

        questionText.text = QuizEntity.getInstance().questions[currentQuestionOrder - 1].questionText
//        option1Text.text = QuizEntity.getInstance().questions[currentQuestionOrder-1].option1 ?? ""
//        option2Text.text = QuizEntity.getInstance().questions[currentQuestionOrder-1].option2 ?? ""
//        option3Text.text = QuizEntity.getInstance().questions[currentQuestionOrder-1].option3 ?? ""
//        option4Text.text = QuizEntity.getInstance().questions[currentQuestionOrder-1].option4 ?? ""
        // TODO: ?? "" <-bunlar aslinda olmyacak. Sorunun tipine gore alicam.

        //ilk soru icin back tusunu kapat
        if currentQuestionOrder == 1 {
            backButton.isHidden = true
        } else {
            backButton.isHidden = false
        }

        //son soru icin next tusu yerine finish yap
        if currentQuestionOrder == QuizEntity.getInstance().questions.count {
            nextButton.setTitle("Finish", for: .normal)
        } else {
            nextButton.setTitle("Next", for: .normal)
        }
    }


    @IBAction func prevQuestion(_ sender: Any) {
        StudentAnswerEntity.getInstance().currentQuestionOrder -= 1
        changeQuestion()
    }

    @IBAction func nextQuestion(_ sender: Any) {
        StudentAnswerEntity.getInstance().currentQuestionOrder += 1
        changeQuestion()
    }

    private func changeQuestion() {
        currentQuestionOrder = StudentAnswerEntity.getInstance().currentQuestionOrder
        var target = "SingleQuizViewVC"
        if QuizEntity.getInstance().questions[currentQuestionOrder - 1].type == "TF" {
            target = "TFQuizViewVC"
        }
        if QuizEntity.getInstance().questions[currentQuestionOrder - 1].type == "M" {
            target = "MultiQuizViewVC"
        }

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: target) as! QuizViewVC
        print(target)
        self.show(nextViewController, sender: nil)
    }


}
