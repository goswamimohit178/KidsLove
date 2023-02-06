//
//  ResultsViewController.swift
//  KidsLove
//
//  Created by Vishnu Dutt on 04/02/23.
//

import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var yourMarks: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var totalMarksOfAll: UILabel!
    
    var correctAnswer: Int = 0
    var totalMarks: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.yourMarks.text = String(correctAnswer)
        self.totalMarksOfAll.text = String(totalMarks)
        footerView.layer.cornerRadius = 0.05 * footerView.bounds.size.width
        headerView.layer.cornerRadius = 0.05 * headerView.bounds.size.width
    }
}
