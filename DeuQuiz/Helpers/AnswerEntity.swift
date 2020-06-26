//
//  QuestionEntity.swift
//  DeuQuiz
//
//  Created by Ferhat Kortak on 13.06.2020.
//  Copyright © 2020 og. All rights reserved.
//

import UIKit

class AnswerEntity {

    init(order: Int, studentAnswer: String, correctAnswer: String, questionText: String, type: String) {
        self.order = order
        self.studentAnswer = studentAnswer
        self.correctAnswer = correctAnswer
        self.questionText = questionText
        self.type = type
        self.isCorrect = (studentAnswer==correctAnswer)
    }

    var order=0
    var studentAnswer = ""
    var correctAnswer = "1"
    var questionText = ""
    var isCorrect = false //studentAnswer==correctAnswer
    var type = "S" // S, M, TF


}
