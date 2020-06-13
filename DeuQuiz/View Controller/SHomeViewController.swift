//
//  HomeViewController.swift
//  DeuQuiz
//
//  Created by admin on 11.03.2020.
//  Copyright © 2020 og. All rights reserved.
//

import UIKit
import Firebase

struct Question {
    let text: String
    let answers: [Answer]
}

struct Answer {
    let text: String
    let correct: Bool // true / false
}

class SHomeViewController: UIViewController {

    @IBOutlet weak var signOut: UIButton!
    @IBOutlet weak var quizCodeText: UITextField!

    var questionModels = [Question]();

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func test(_ sender: Any) {
        
    }
    @IBAction func signOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let homeViewController = self.storyboard?.instantiateViewController(identifier: "HomeVC") as? ViewController
            self.view.window?.rootViewController = homeViewController
            self.view.window?.makeKeyAndVisible()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

    @IBAction func enterToQuiz(_ sender: Any) {
        let db = Firestore.firestore()
        let myQuizRef = db.collection("quiz").document(quizCodeText.text!)

        //enter the quiz
        myQuizRef.getDocument { (document, error) in
            if let document = document, document.exists {
                //entered the quiz successfully.

                // Add me to participants
                self.addMeToParticipants(quizRef: myQuizRef)


                // Take the questions
                self.takeTheQuestions(quizRef: myQuizRef)


//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
            } else {
                print("Quiz does not exist")
            }
        }


    }

// enterToQuiz - HELPER
    private func takeTheQuestions(quizRef myQuizRef: DocumentReference) {
        let questionRef = myQuizRef.collection("questions")
        questionRef.getDocuments() { (questions, err) in
            if let err = err {
                print("Error getting questions: \(err)")
            } else {
                for question in questions!.documents {
                    print("\(question.documentID) => \(question.data())")
                    self.questionModels.append(Question(text: question.documentID + ") " + (question.data()["question"] as! String), answers: [
                        Answer(text: question.data()["option1"] as! String, correct: (question.data()["correct"] as! String)=="option1"),
                        Answer(text: question.data()["option2"] as! String, correct: (question.data()["correct"] as! String)=="option2"),
                        Answer(text: question.data()["option3"] as! String, correct: (question.data()["correct"] as! String)=="option3"),
                        Answer(text: question.data()["option4"] as! String, correct: (question.data()["correct"] as! String)=="option4")
                    ]))
                }
                print("questionModels: ",self.questionModels)
            }

        }

    }

    private func addMeToParticipants(quizRef myQuizRef: DocumentReference) {
        let participantsRef = myQuizRef.collection("participants")
        participantsRef.addDocument(data: [
            "uid": Auth.auth().currentUser!.uid,
            "email": Auth.auth().currentUser!.email,
            "enterTime": Date(timeIntervalSince1970: Date().timeIntervalSince1970)
        ]) { err in
            if let err = err {
                print("Error adding student info to participants: \(err)")
            }
        }
        print("successful")
    }
}

