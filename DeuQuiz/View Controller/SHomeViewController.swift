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
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  @IBAction func signOut(_ sender: Any) {
    let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
      let homeViewController = self.storyboard?.instantiateViewController(identifier: "HomeVC") as? ViewController
      self.view.window?.rootViewController = homeViewController
      self.view.window?.makeKeyAndVisible()
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
  }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
