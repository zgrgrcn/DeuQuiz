//
//  HomeViewController.swift
//  DeuQuiz
//
//  Created by admin on 11.03.2020.
//  Copyright © 2020 og. All rights reserved.
//

import UIKit
import Firebase

struct Quiz {
    var prevQuizName: String
    var correctNumber: String
    var wrongNumber: String
}
class SHomeViewController: UIViewController {

    @IBOutlet weak var signOut: UIButton!
    @IBOutlet weak var quizCodeText: UITextField!
    @IBOutlet weak var enterQuizButton: UIButton!
    @IBOutlet weak var quizTableView: UITableView!

    var fakeQuizNames = [""]
    var prevQuizzes : [Quiz] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getPrevQuizzes()
        quizTableView.delegate = self
        quizTableView.dataSource = self

        setUpElement()
        //      StudentAnswerEntity.getInstance()
    }

    private func getPrevQuizzes() {


        let db = Firestore.firestore()
        let myStudentRef = db.collection("students").whereField("uid", isEqualTo: Auth.auth().currentUser!.uid)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            for data in document.data() {
                                if data.key.count==6{
                                    self.prevQuizzes.append(Quiz(prevQuizName: data.key, correctNumber: String((data.value as! String).split(separator: "|")[0]), wrongNumber: String((data.value as! String).split(separator: "|")[1])))
                                    self.quizTableView.reloadData()
                                }
                            }
                        }

                    }
                }
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

    func showActivityIndicator() {

        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)

        activityIndicator.center = self.view.center
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)

        activityIndicator.startAnimating()

    }

    @IBAction func enterToQuiz(_ sender: UIButton) {

        sender.isEnabled = false

        showActivityIndicator()

        let db = Firestore.firestore()
        let myQuizRef = db.collection("quiz").document(quizCodeText.text!)

        //enter the quiz
        myQuizRef.getDocument { (document, error) in
            if let document = document, document.exists {
                //entered the quiz successfully.

                // Add me to participants
                self.addMeToParticipants(quizRef: myQuizRef)

                // Take quiz metadata
                self.takeQuizMetadata(quizRef: myQuizRef, quizCode: self.quizCodeText.text!)

                // Take the questions and start the quiz
                self.takeTheQuestionsAndGoToQuiz(quizRef: myQuizRef)


            } else {
                print("Quiz does not exist")
            }
        }


    }

    //- enterToQuiz Flow
    private func addMeToParticipants(quizRef myQuizRef: DocumentReference) {
        let participantsRef = myQuizRef.collection("participants")
        participantsRef.document(Auth.auth().currentUser!.uid).setData([
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

    private func takeQuizMetadata(quizRef: DocumentReference, quizCode: String) {
        quizRef.getDocument() { (document, error) in
            if let document = document, document.exists {
                QuizEntity.getInstance().isDone = ((document.data()!["isDone"] as! String) as NSString).boolValue
                QuizEntity.getInstance().duration = document.data()!["duration"] as! Int
                QuizEntity.getInstance().teacherID = document.data()!["teacherID"] as! String
                QuizEntity.getInstance().title = document.data()!["quizName"] as! String
                QuizEntity.getInstance().enterCode = quizCode
                //QuizEntity.getInstance().createdDate = document.data()!["createdDate"] as! Timestamp  // as! Date de olmadi //TODO: bunu cozemedim
            } else {
                print("Document does not exist")
            }
        }
    }

    private func takeTheQuestionsAndGoToQuiz(quizRef myQuizRef: DocumentReference) {
        let questionRef = myQuizRef.collection("questions")
        questionRef.getDocuments() { (questions, err) in
            if let err = err {
                print("Error getting questions: \(err)")
            } else {
                QuizEntity.getInstance().questions=[]
                StudentAnswerEntity.getInstance().answers=[]
                StudentAnswerEntity.getInstance().currentQuestionOrder=0
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

    //- HELPER functions
    private func setUpElement() {
        // Style the elements
        Utilities.styleFilledButton(enterQuizButton)
    }
}

extension SHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let text = cell?.textLabel?.text
        print(text)
        goToStatistics(quizCode: text)
    }

    private func goToStatistics(quizCode: String?) {
        if quizCode != "" {
            let homeViewController = self.storyboard?.instantiateViewController(identifier: "StatisticsVC") as? StatsVC
            for quiz in prevQuizzes {
                if quiz.prevQuizName==quizCode {
                    homeViewController?.quiz=quiz
                }
            }
            self.view.window?.rootViewController = homeViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
}

extension SHomeViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {



        return prevQuizzes.count // There are three rows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = prevQuizzes[indexPath.row].prevQuizName as! String

        return cell
    }
}
