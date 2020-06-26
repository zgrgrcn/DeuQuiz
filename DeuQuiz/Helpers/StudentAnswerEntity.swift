//
//  StudentAnswerEntity.swift
//  DeuQuiz
//
//  Created by Ferhat Kortak on 14.06.2020.
//  Copyright © 2020 og. All rights reserved.
//

import UIKit

class StudentAnswerEntity {

    private init() {
    }

    private static var quiz: StudentAnswerEntity = {
        let instance = StudentAnswerEntity()
        // setup code
        return instance
    }()

    class func getInstance() -> StudentAnswerEntity {
        return quiz
    }

    class func addNewAnswer(order: Int, studentAnswer: String, correctAnswer: String, questionText: String, type: String) {

        var _index = -1;
        for (index, answer) in self.getInstance().answers.enumerated() {
            if order == answer.order { //gelenin `order` i cevaplardaki herhangibir `order`la ayniysa
                _index = index
            }
        }
        //else
        if _index != -1 {//update answer
            self.getInstance().answers[_index]=AnswerEntity(order: order, studentAnswer: studentAnswer, correctAnswer: correctAnswer, questionText: questionText, type: type)
        } else {//insert new answer
            self.getInstance().answers.append(AnswerEntity(order: order, studentAnswer: studentAnswer, correctAnswer: correctAnswer, questionText: questionText, type: type))

        }
    }

    var quizID = ""
    var studentID = ""
    var remainingTime = 10
    var currentQuestionOrder = 0 //hangi soruyu cevapladigimi bilmek icin
    var answers = [AnswerEntity]()

}
