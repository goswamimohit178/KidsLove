//
//  OperatorTableViewCell.swift
//  KidsLove
//
//  Created by Vikash on 07/02/23.
//

import UIKit

class OperatorTableViewCell: UITableViewCell {
    
    var buttonTappedAction: (() -> Void)?
    @IBOutlet weak var unitNumberLabel: UILabel!
    
    @IBOutlet weak var chapterNameLabel: UILabel!
    
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var roundingButton: UIButton!
    @IBOutlet weak var chainsButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var easyLabel: UILabel!
    @IBOutlet weak var mediumlabel: UILabel!
    @IBOutlet weak var hardLabel: UILabel!
    @IBOutlet weak var chainsLabel: UILabel!
    @IBOutlet weak var roundingLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    
    private var circularViewDuration: TimeInterval = 2
    
    
    @IBAction func mediumButtonTapped(_ sender: Any) {
        
    }

    @IBAction func easyButtonTapped(_ sender: Any) {
        buttonTappedAction!()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        makeButtonRound()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    private func makeButtonRound() {
        easyButton.layer.cornerRadius = easyButton.bounds.width / 2
        mediumButton.layer.cornerRadius = mediumButton.bounds.size.width / 2 
        roundingButton.layer.cornerRadius = roundingButton.bounds.size.width / 2
        chainsButton.layer.cornerRadius = chainsButton.bounds.size.width / 2
        hardButton.layer.cornerRadius = hardButton.bounds.size.width / 2
        reviewButton.layer.cornerRadius = reviewButton.bounds.size.width / 2

    }
    
    func setProgressAnimation() {
        setUpCircularProgressBarView(button: easyButton)
    }
    
    func setUpCircularProgressBarView(button: UIButton) {
        button.createCircularPath(duration: circularViewDuration, progress: .complete)
    }
    
}

extension UIButton {
    func createCircularPath(duration: TimeInterval, progress: Progress) {
        let progressLayer = CAShapeLayer()
        let startPoint = CGFloat(-Double.pi / 2)
        let endPoint = CGFloat(3 * Double.pi / 2)
            // created circularPath for circleLayer and progressLayer
            let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 52, startAngle: startPoint, endAngle: endPoint, clockwise: true)
           
            progressLayer.path = circularPath.cgPath
            // ui edits
            progressLayer.fillColor = UIColor.clear.cgColor
            progressLayer.lineCap = .round
            progressLayer.lineWidth = 16.0
            progressLayer.strokeEnd = 0
            progressLayer.strokeColor = UIColor.green.cgColor
            // added progressLayer to layer
            layer.addSublayer(progressLayer)
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        // set the end time
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = progress.progress
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
    
}

  
