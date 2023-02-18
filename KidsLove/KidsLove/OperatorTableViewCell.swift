//
//  OperatorTableViewCell.swift
//  KidsLove
//
//  Created by Vikash on 07/02/23.
//

import UIKit

class OperatorTableViewCell: UITableViewCell {
    
    var buttonTappedAction: (([Question], _ levelType: LevelType, Int) -> Void)?
    @IBOutlet weak var unitNumberLabel: UILabel!
    @IBOutlet weak var chapterNameLabel: UILabel!
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var chainsButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    @IBOutlet weak var easyLabel: UILabel!
    @IBOutlet weak var mediumlabel: UILabel!
    @IBOutlet weak var hardLabel: UILabel!
    @IBOutlet weak var chainsLabel: UILabel!
    @IBOutlet weak var tittleView: UIView!
    @IBOutlet weak var buttonHeightConstarint: NSLayoutConstraint!
    private var circularViewDuration: TimeInterval = 2
    var unit:Unit!
    var currUnit: Int?
    private var buttonWidth: CGFloat = 150
    var buttons: [UIButton] = []
    
    @IBAction func mediumButtonTapped(_ sender: Any) {
        buttonTappedAction!(unit.levels.mediumLevel.questions(), .medium, currUnit!)
        
    }
    @IBAction func easyButtonTapped(_ sender: Any) {
//        var test: Int?
//        print(test!)
        buttonTappedAction!(unit.levels.easyLevel.questions(), .easy , currUnit!)
    }
    
    @IBAction func hardButtonTapped(_ sender: Any) {
        buttonTappedAction!(unit.levels.hardLevel.questions(), .hard, currUnit!)
    }
   
    @IBAction func practiceButtonTapped(_ sender: Any) {
        buttonTappedAction!(unit.levels.chainsLevel.questions(), .practice, currUnit!)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buttonWidth = UIScreen.main.bounds.width * 0.2
        setFontsAndColor()
        makeButtonRound()
        appendBtnsInArray()
        buttonHeightConstarint.constant = buttonWidth
    }
    
    func setTittleOperatorBtn(chapterName: String) {
        
        for btn in buttons {
            if chapterName == "Multiplication" {
                btn.setTitle("X", for: .normal)
            } else if chapterName == "Division" {
                btn.setTitle("÷", for: .normal)
            } else if chapterName == "Addition" {
                btn.setTitle("+", for: .normal)
            }  else {
                btn.setTitle("-", for: .normal)
            }
        }
        
    }
    
    func appendBtnsInArray() {
        buttons.append(easyButton)
        buttons.append(mediumButton)
        buttons.append(hardButton)
        buttons.append(chainsButton)
    }
    
    
    func disableBtnForProgress(unit: Unit) {
        mediumButton.isEnabled =  (unit.levels.easyLevel.progress == .complete)
        hardButton.isEnabled = ( unit.levels.mediumLevel.progress == .complete )
        chainsButton.isEnabled = ( unit.levels.hardLevel.progress == .complete )
    }
    
    func setColorForDisableBtn() {
        for button in buttons {
            if !button.isEnabled {
                button.alpha = 0.5
                button.backgroundColor = UIColor.disableButtonColor()
              
            } else {
                button.backgroundColor = UIColor.homeButtonColor()
            }
        }
        
    }
    
    func setDataCell() {
        self.unitNumberLabel.text = unit.unitNumber
        self.chapterNameLabel.text = unit.chapterName
        self.easyLabel.text = unit.levels.easyLevel.title
        self.mediumlabel.text = unit.levels.mediumLevel.title
        self.hardLabel.text = unit.levels.hardLevel.title
        self.chainsLabel.text = unit.levels.chainsLevel.title
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    private func makeButtonRound() {
        easyButton.layer.cornerRadius = buttonWidth / 2.0
        mediumButton.layer.cornerRadius = buttonWidth / 2.0
        chainsButton.layer.cornerRadius = buttonWidth / 2.0
        hardButton.layer.cornerRadius = buttonWidth / 2.0
    }
    
    func setProgressAnimation() {
        removeProgressLayer(button: easyButton)
        removeProgressLayer(button: mediumButton)
        removeProgressLayer(button: hardButton)
        removeProgressLayer(button: chainsButton)
        setUpCircularProgressBarView(button: easyButton, progress: unit.levels.easyLevel.progress)
        setUpCircularProgressBarView(button: mediumButton, progress: unit.levels.mediumLevel.progress)
        setUpCircularProgressBarView(button: hardButton, progress: unit.levels.hardLevel.progress)
        setUpCircularProgressBarView(button: chainsButton, progress: unit.levels.chainsLevel.progress)
    }
    
    func setUpCircularProgressBarView(button: UIButton, progress: Progress) {
        button.createCircularPath(duration: circularViewDuration, progress: progress, buttonWidth: buttonWidth)
    }
    
    private func removeProgressLayer(button: UIButton) {
        button.layer.sublayers?.forEach({ layer in
            if layer is CAShapeLayer {
                layer.removeFromSuperlayer()
            }
        })
    }
    
    
    private func setFontsAndColor() {
        unitNumberLabel.font = UIFont.headingFonts()
        chapterNameLabel.font = UIFont.operatorViewCellFont()
        easyLabel.font = UIFont.operatorViewCellFont()
        mediumlabel.font = UIFont.operatorViewCellFont()
        hardLabel.font = UIFont.operatorViewCellFont()
        chainsLabel.font = UIFont.operatorViewCellFont()
        easyButton.backgroundColor = UIColor.homeButtonColor()
        mediumButton.backgroundColor = UIColor.homeButtonColor()
        hardButton.backgroundColor = UIColor.homeButtonColor()
        chainsButton.backgroundColor = UIColor.homeButtonColor()
        tittleView.backgroundColor = UIColor.homeButtonColor()
        easyButton.titleLabel?.font = UIFont.myAppBodyFonts()
        mediumButton.titleLabel?.font = UIFont.myAppBodyFonts()
        hardButton.titleLabel?.font = UIFont.myAppBodyFonts()
        chainsButton.titleLabel?.font = UIFont.myAppBodyFonts()
        
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
        progressLayer.lineWidth = buttonWidth * 0.15
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.operatorProgressBar().cgColor
        // added progressLayer to layer
        layer.addSublayer(progressLayer)
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = progress.progress
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}
