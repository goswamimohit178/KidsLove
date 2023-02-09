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
        setFontsAndColor()
        makeButtonRound()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    private func makeButtonRound() {
        easyButton.layer.cornerRadius = easyButton.bounds.size.width / 2
        mediumButton.layer.cornerRadius = 0.475 * mediumButton.bounds.size.width
        roundingButton.layer.cornerRadius = 0.475 * roundingButton.bounds.size.width
        chainsButton.layer.cornerRadius = 0.475 * chainsButton.bounds.size.width
        hardButton.layer.cornerRadius = 0.475 * hardButton.bounds.size.width
        reviewButton.layer.cornerRadius = 0.475 * reviewButton.bounds.size.width
        
    }
    
    func setProgressAnimation() {
        setUpCircularProgressBarView(button: easyButton)
    }
    
    func setUpCircularProgressBarView(button: UIButton) {
        button.createCircularPath(duration: circularViewDuration, progress: .oneThird)
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
        
    }
    
}

extension UIButton {
    func createCircularPath(duration: TimeInterval, progress: Progress) {
        let progressLayer = CAShapeLayer()
        let startPoint = CGFloat(-Double.pi / 2)
        let endPoint = CGFloat(3 * Double.pi / 2)
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 55, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 16.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.operatorProgressBar().cgColor
        layer.addSublayer(progressLayer)
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 1
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
    
}

