//
//  StudentAnswerEntity.swift
//  DeuQuiz
//
//  Created by Ferhat Kortak on 14.06.2020.
//  Copyright © 2020 og. All rights reserved.
//

import UIKit

class StudentAnswerEntity {
    
     private init() { }
    
     private static var quiz: StudentAnswerEntity = {
         let instance = StudentAnswerEntity()
         // setup code
         return instance
     }()
    
    class func getInstance() -> StudentAnswerEntity{
        return quiz
    }
    
    class func addNewAnswer(answer: String)
    {
        self.getInstance().answers.append(answer)
    }
    
    var quizID = ""
    var studentID = ""
    var remainingTime = 10
    var currentQuestionOrder = 1 //hangi soruyu cevapladigimi bilmek icin
    var answers = [String]()

}
