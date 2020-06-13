//
//  QuizEntity.swift
//  DeuQuiz
//
//  Created by Ferhat Kortak on 13.06.2020.
//  Copyright © 2020 og. All rights reserved.
//

import UIKit

class QuizEntity {
    
     private init() { }
    
     private static var quiz: QuizEntity = {
         let instance = QuizEntity()
         // setup code
         return instance
     }()
    
    class func getInstance() -> QuizEntity{
        return quiz
    }
    
    class func addNewQuestion(order: Int, option1:String, option2:String, option3:String, option4:String,
                              correct:String, questionText:String)
    {
        self.getInstance().questions.append(QuestionEntity(order:order,option1: option1, option2: option2, option3: option3, option4: option4,
                                                           correct: correct, questionText:questionText))
    }
    
    var title = ""
    var isDone = false
    var createdDate = Date(timeIntervalSince1970: Date().timeIntervalSince1970)
    var teacherID = ""
    var duration = 10
    var enterCode = ""
    
    var questions = [QuestionEntity]()

}

