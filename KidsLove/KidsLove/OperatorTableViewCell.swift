//
//  OperatorTableViewCell.swift
//  KidsLove
//
//  Created by Vikash on 07/02/23.
//

import UIKit

class OperatorTableViewCell: UITableViewCell {
    
    var buttonTappedAction: (([Question]) -> Void)?
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
    @IBOutlet weak var tittleView: UIView!
    @IBOutlet weak var buttonHeightConstarint: NSLayoutConstraint!
    private var circularViewDuration: TimeInterval = 2
    var unit:Unit!
    private var buttonWidth: CGFloat = 150
    
    @IBAction func mediumButtonTapped(_ sender: Any) {
        buttonTappedAction!(unit.levels.mediumLevel.questions)
        
    }
    @IBAction func easyButtonTapped(_ sender: Any) {
        
        buttonTappedAction!(unit.levels.easyLevel.questions)
    }
    
    @IBAction func hardButtonTapped(_ sender: Any) {
        buttonTappedAction!(unit.levels.hardLevel.questions)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setFontsAndColor()
        makeButtonRound()
        buttonHeightConstarint.constant = buttonWidth
    }
    
    private func setDataCell() {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    private func makeButtonRound() {
        easyButton.layer.cornerRadius = buttonWidth / 2.0
        mediumButton.layer.cornerRadius = buttonWidth / 2.0
        roundingButton.layer.cornerRadius = buttonWidth / 2.0
        chainsButton.layer.cornerRadius = buttonWidth / 2.0
        hardButton.layer.cornerRadius = buttonWidth / 2.0
        reviewButton.layer.cornerRadius = buttonWidth / 2.0
    }
    
    func setProgressAnimation() {
        setUpCircularProgressBarView(button: easyButton)
    }
    
    func setUpCircularProgressBarView(button: UIButton) {
        button.createCircularPath(duration: circularViewDuration, progress: .complete, buttonWidth: buttonWidth)
    }
    
    private func setFontsAndColor() {
        unitNumberLabel.font = UIFont.myAppBodyFonts()
        chapterNameLabel.font = UIFont.operatorViewCellFont()
        easyLabel.font = UIFont.operatorViewCellFont()
        mediumlabel.font = UIFont.operatorViewCellFont()
        hardLabel.font = UIFont.operatorViewCellFont()
        chainsLabel.font = UIFont.operatorViewCellFont()
        roundingLabel.font = UIFont.operatorViewCellFont()
        reviewLabel.font = UIFont.operatorViewCellFont()
        easyButton.backgroundColor = UIColor.homeButtonColor()
        mediumButton.backgroundColor = UIColor.homeButtonColor()
        hardButton.backgroundColor = UIColor.homeButtonColor()
        chainsButton.backgroundColor = UIColor.homeButtonColor()
        roundingButton.backgroundColor = UIColor.homeButtonColor()
        reviewButton.backgroundColor = UIColor.homeButtonColor()
        tittleView.backgroundColor = UIColor.homeButtonColor()
    }
    
}

extension UIButton {
    func createCircularPath(duration: TimeInterval, progress: Progress, buttonWidth: CGFloat) {
        let progressLayer = CAShapeLayer()
        let startPoint = CGFloat(-Double.pi / 2)
        let endPoint = CGFloat(3 * Double.pi / 2)
            // created circularPath for circleLayer and progressLayer
            let circularPath = UIBezierPath(arcCenter: CGPoint(x: (buttonWidth / 2.0), y: (buttonWidth / 2.0)), radius: buttonWidth / 2.0, startAngle: startPoint, endAngle: endPoint, clockwise: true)
           
            progressLayer.path = circularPath.cgPath
            // ui edits
            progressLayer.fillColor = UIColor.clear.cgColor
            progressLayer.lineCap = .round
            progressLayer.lineWidth = 16.0
            progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.operatorProgressBar().cgColor            // added progressLayer to layer
        layer.addSublayer(progressLayer)
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = progress.progress
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}


