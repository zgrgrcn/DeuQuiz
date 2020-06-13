//
//  QuestionEntity.swift
//  DeuQuiz
//
//  Created by Ferhat Kortak on 13.06.2020.
//  Copyright © 2020 og. All rights reserved.
//

import UIKit

class QuestionEntity {
    

    init(option1:String, option2:String, option3:String, option4:String,
         correct:String, questionText:String) {
        self.option1 = option1
        self.option2 = option1
        self.option3 = option1
        self.option4 = option1
        self.correctAnswer = option1
        self.questionText = questionText
    }
    
    var questionText = ""
    
    var option1 = ""
    var option2 = ""
    var option3 = ""
    var option4 = ""
    
    var correctAnswer = "1"
    

}
