//
//  GameOptionVC.swift
//  PhotoPuzzle
//
//  Created by Kaliannan, Vaideeswaran on 11/15/19.
//  Copyright © 2019 Ramon Rodriguez. All rights reserved.
//

import UIKit

class GameOptionVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnScoreBoard(_ sender: Any) {
        self.performSegue(withIdentifier: "gameOption2ScoreBoard", sender: self)
    }
    
    @IBAction func btnNewGame(_ sender: Any) {
        self.performSegue(withIdentifier: "gameOption2GameControl", sender: self)
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
