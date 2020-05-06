//
//  GamerNameVC.swift
//  PhotoPuzzle
//
//  Created by Dinesh Yeligandla on 12/12/19.
//  Copyright © 2019 Ramon Rodriguez. All rights reserved.
//

import UIKit

class GamerNameVC: UIViewController {
    @IBOutlet weak var btnSubmitName: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    var coutDown = 0.00
    var moves = 0
    @IBOutlet weak var txtGamersName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        if (txtGamersName.text) != nil {
        let score = Int(self.coutDown/6) - self.moves + 20
                                   let flooredCounter = Int(floor(30-coutDown))
                                   let hour = flooredCounter/3600
                                   let minute = (flooredCounter%3600)/60
                                   var minuteString = "\(minute)"
                                   if minute < 10 {
                                       minuteString = "0\(minute)"
                                   }
                                   let second = (flooredCounter%3600)%60
                                   var secondString = "\(second)"
                                   if second < 10 {
                                       secondString = "0\(second)"
                                   }
                                   
                                   let time = "\(hour):\(minuteString):\(secondString)"
            
        ScoreboardCRUD.create(newName: txtGamersName.text!, newMove: String(moves), newTime: String(time), newScore: String(score))
            btnSubmitName.isEnabled = false
        self.performSegue(withIdentifier: "GamerName2ScoreBoard", sender: self)
        }
    }
    
    
    
    @IBAction func btnActionBack(_sender: Any)
    {
        dismiss(animated: true, completion: nil)
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
