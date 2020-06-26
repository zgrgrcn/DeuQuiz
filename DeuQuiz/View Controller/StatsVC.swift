//
//  StatsVC.swift
//  DeuQuiz
//
//  Created by Ferhat Kortak on 20.06.2020.
//  Copyright © 2020 og. All rights reserved.
//

import UIKit
import Firebase
import Accelerate

class StatsVC: UIViewController {

    @IBOutlet weak var quizNameLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var standarDeviationLabel: UILabel!
    @IBOutlet weak var totalParticipantsLabel: UILabel!
    @IBOutlet weak var myScoreLabel: UILabel!
    
    var quiz: Quiz=Quiz(prevQuizName: "", correctNumber: "", wrongNumber: "")
    var totalParticipantsCount: Int=0 //20kisi katildi
    //var totalCorrectAnswer: Int=0  //toplam 90dogru
    var average: Double=0.0  //ortalama 4.5dogru
    var correctAnswerForAllParticipants: [Double] = [0.0]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1: quiz codunu kaydet => SHomeViewController dan geliyor
        quizNameLabel.text=quiz.prevQuizName
        myScoreLabel.text=quiz.correctNumber

        // 2:firebaseden bu quize katilan kisi sayisini kaydet
        let db = Firestore.firestore()
        let myQuizRef = db.collection("quiz").document(quiz.prevQuizName)
        let participantsRef=myQuizRef.collection("participants")
        participantsRef.getDocuments()
        {
            (querySnapshot, err) in

            if let err = err
            {
                print("Error getting documents: \(err)");
            }
            else
            {
                self.correctAnswerForAllParticipants.remove(at: 0)
                for document in querySnapshot!.documents {
                    self.totalParticipantsCount += 1
                   // self.totalCorrectAnswer += document.data()["totalCorrect"] as! Int
                    self.correctAnswerForAllParticipants.append(document.data()["totalCorrect"] as! Double)
                }
                var mn = 0.0
                var sddev = 0.0
                //self.average = Double(self.totalCorrectAnswer/self.totalParticipantsCount)
                vDSP_normalizeD(self.correctAnswerForAllParticipants, 1, nil, 1, &mn, &sddev, vDSP_Length(self.correctAnswerForAllParticipants.count))
                sddev *= sqrt(Double(self.correctAnswerForAllParticipants.count)/Double(self.correctAnswerForAllParticipants.count - 1))

                print(mn, sddev)
                if sddev.isNaN {
                    sddev=0
                }
                self.standarDeviationLabel.text=String(sddev)
                self.averageLabel.text=String(mn)
                self.totalParticipantsLabel.text=String(self.totalParticipantsCount)
            }
        }


        //tum katilimcilarin correct false sayilarina bakarak average ve SD hesapla
    }
    @IBAction func backToSHomeVC(_ sender: UIButton) {
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SHomeVC") as! SHomeViewController
//        self.show(nextViewController, sender: nil)

        let homeViewController = self.storyboard?.instantiateViewController(identifier: "SHomeVC") as? SHomeViewController
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()

    }
}