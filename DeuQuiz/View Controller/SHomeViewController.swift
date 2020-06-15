//
//  HomeViewController.swift
//  DeuQuiz
//
//  Created by admin on 11.03.2020.
//  Copyright © 2020 og. All rights reserved.
//

import UIKit
import Firebase


class SHomeViewController: UIViewController {

    @IBOutlet weak var signOut: UIButton!
    @IBOutlet weak var quizCodeText: UITextField!
    @IBOutlet weak var enterQuizButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElement()
        //      StudentAnswerEntity.getInstance()
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

                // Take quiz metadata
                self.takeQuizMetadata(quizRef: myQuizRef)

                // Take the questions and start the quiz
                self.takeTheQuestionsAndGoToQuiz(quizRef: myQuizRef)


            } else {
                print("Quiz does not exist")
            }
        }


    }

    private func takeQuizMetadata(quizRef: DocumentReference) {
        quizRef.getDocument() { (document, error) in
            if let document = document, document.exists {
                QuizEntity.getInstance().isDone = ((document.data()!["isDone"] as! String) as NSString).boolValue
                QuizEntity.getInstance().duration = document.data()!["duration"] as! Int
                QuizEntity.getInstance().teacherID = document.data()!["teacherID"] as! String
                QuizEntity.getInstance().title = document.data()!["quizName"] as! String
                //QuizEntity.getInstance().createdDate = document.data()!["createdDate"] as! Timestamp  // as! Date de olmadi //TODO: bunu cozemedim
            } else {
                print("Document does not exist")
            }
        }
    }

    private func goToQuiz() {
        // TODO:delete these comments
        //sorulari gostermeye baslayabiliriz ancak asenkron calistigi icin sorularin tamamini almadan diger sayfa gozukebilir???
        QuizEntity.getInstance().questions = QuizEntity.getInstance().questions.sorted(by: { $0.order < $1.order }) // Bunu bulana kadar canim cikti lol
        var target = "SingleQuizViewVC"
        if QuizEntity.getInstance().questions[0].type == "TF" {
            target = "TFQuizViewVC"
        }
        if QuizEntity.getInstance().questions[0].type == "M" {
            target = "MultiQuizViewVC"
        }

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: target) as! QuizViewVC
        self.show(nextViewController, sender: nil)
    }

// enterToQuiz - HELPER
    private func takeTheQuestionsAndGoToQuiz(quizRef myQuizRef: DocumentReference) {
        let questionRef = myQuizRef.collection("questions")
        questionRef.getDocuments() { (questions, err) in
            if let err = err {
                print("Error getting questions: \(err)")
            } else {
                for question in questions!.documents {
                    print("\(question.documentID) => \(question.data())")
                    QuizEntity.addNewQuestion(
                            order: question.data()["order"]! as! Int,
                            option1: question.data()["option1"]! as! String, option2: question.data()["option2"]! as! String, option3: question.data()["option3"]! as! String, option4: question.data()["option4"]! as! String,
                            correct: question.data()["correct"]! as! String,
                            questionText: question.data()["question"]! as! String,
                            type: question.data()["type"]! as! String
                    )


                }

                self.goToQuiz()//belki bunu go to quiz yerine go to loby felan yapariz bilmiyorum
            }

        }

    }

    private func addMeToParticipants(quizRef myQuizRef: DocumentReference) {
        let participantsRef = myQuizRef.collection("participants")
        participantsRef.addDocument(data: [
            "uid": Auth.auth().currentUser!.uid,
            "email": Auth.auth().currentUser!.email!,
            "enterTime": Date(timeIntervalSince1970: Date().timeIntervalSince1970)
        ]) { err in
            if let err = err {
                print("Error adding student info to participants: \(err)")
            }
        }
        print("added to participants")
    }

    private func setUpElement() {
        // Style the elements
        Utilities.styleFilledButton(enterQuizButton)
    }
}



