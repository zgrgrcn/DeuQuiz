//
//  AllQuizVC.swift
//  DeuQuiz
//
//  Created by Ferhat Kortak on 20.06.2020.
//  Copyright © 2020 og. All rights reserved.
//

import UIKit

class AllQuizVC: UIViewController {

    @IBOutlet weak var quizTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        quizTableView.delegate = self
        quizTableView.dataSource = self
        
    }
}

extension AllQuizVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped me!")
    }
}

extension AllQuizVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // There are three rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "Hello World"
        
        return cell
    }
}
