//
//  QuizEntity.swift
//  DeuQuiz
//
//  Created by Ferhat Kortak on 13.06.2020.
//  Copyright © 2020 og. All rights reserved.
//

import UIKit

class QuizEntity {
    
    init() {
        
    }
    
    var name = ""
    var isDone = false
    var createdDate = Date(timeIntervalSince1970: Date().timeIntervalSince1970)
    var teacherID = ""
    var duration = 10
    var enterCode = ""
    
    var questions = [QuestionEntity]()

}

