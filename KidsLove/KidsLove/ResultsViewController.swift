//
//  ResultsViewController.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 04/02/23.
//

import UIKit

class ResultsViewController: UIViewController {
    
    var correctAnswer: Int = 0
    var totalMarks: Int = 0
    
    
    @IBOutlet weak var yourMarks: UILabel!
    
    
    @IBOutlet weak var totalMarksOfAll: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   print(correctAnswer)
        
        self.yourMarks.text = String(correctAnswer)
        self.totalMarksOfAll.text = String(totalMarks)
        
    }
}
