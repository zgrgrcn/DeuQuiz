//
//  QuestionEntity.swift
//  DeuQuiz
//
//  Created by Ferhat Kortak on 13.06.2020.
//  Copyright © 2020 og. All rights reserved.
//

import UIKit

class QuestionEntity {

    init(order: Int, option1: String, option2: String, option3: String, option4: String,
         correct: String, questionText: String, type: String) {
        self.order = order
        self.option1 = option1
        self.option2 = option2
        self.option3 = option3
        self.option4 = option4
        self.correctAnswer = correct
        self.questionText = questionText
        self.type = type
    }

    var questionText = ""
    var order = 1
    var option1 = ""
    var option2 = ""
    var option3 = ""
    var option4 = ""

    var correctAnswer = "1"

    var type = "S" // S, M, TF


}
