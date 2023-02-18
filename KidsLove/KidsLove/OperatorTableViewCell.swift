//
//  OperatorTableViewCell.swift
//  KidsLove
//
//  Created by Vikash on 07/02/23.
//

import UIKit

//class OperatorTableViewCell: UITableViewCell {

//    var buttonTappedAction: (([Question], _ levelType: LevelType, Int) -> Void)?
//    @IBOutlet weak var unitNumberLabel: UILabel!
//    @IBOutlet weak var chapterNameLabel: UILabel!
//    @IBOutlet weak var easyButton: UIButton!
//    @IBOutlet weak var mediumButton: UIButton!
//    @IBOutlet weak var chainsButton: UIButton!
//    @IBOutlet weak var hardButton: UIButton!
//    @IBOutlet weak var easyLabel: UILabel!
//    @IBOutlet weak var mediumlabel: UILabel!
//    @IBOutlet weak var hardLabel: UILabel!
//    @IBOutlet weak var chainsLabel: UILabel!
//    @IBOutlet weak var tittleView: UIView!
//    @IBOutlet weak var buttonHeightConstarint: NSLayoutConstraint!
//    private var circularViewDuration: TimeInterval = 2
//    var unit:Unit!
//    var currUnit: Int?
//    private var buttonWidth: CGFloat = 150
//    var buttons: [UIButton] = []
//
//    @IBAction func mediumButtonTapped(_ sender: Any) {
//        buttonTappedAction!(unit.levels.mediumLevel.questions(), .medium, currUnit!)
//
//    }
//    @IBAction func easyButtonTapped(_ sender: Any) {
//        buttonTappedAction!(unit.levels.easyLevel.questions(), .easy , currUnit!)
//    }
//
//    @IBAction func hardButtonTapped(_ sender: Any) {
//        buttonTappedAction!(unit.levels.hardLevel.questions(), .hard, currUnit!)
//    }
//
//    @IBAction func practiceButtonTapped(_ sender: Any) {
//        buttonTappedAction!(unit.levels.chainsLevel.questions(), .practice, currUnit!)
//    }
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.buttonWidth = UIScreen.main.bounds.width * 0.2
//        setFontsAndColor()
//        makeButtonRound()
//        appendBtnsInArray()
//        buttonHeightConstarint.constant = buttonWidth
//    }

//    func setTittleOperatorBtn(chapterName: String) {
//        
//        for btn in buttons {
//            if chapterName == "Multiplication" {
//                btn.setTitle("X", for: .normal)
//            } else if chapterName == "Division" {
//                btn.setTitle("÷", for: .normal)
//            } else if chapterName == "Addition" {
//                btn.setTitle("+", for: .normal)
//            }  else {
//                btn.setTitle("-", for: .normal)
//            }
//        }
//        
//    }
//    
//    func appendBtnsInArray() {
////        buttons.append(easyButton)
////        buttons.append(mediumButton)
////        buttons.append(hardButton)
////        buttons.append(chainsButton)
//    }
//    
//    
//    func disableBtnForProgress(unit: Unit) {
//        mediumButton.isEnabled =  (unit.levels.easyLevel.progress == .complete)
//        hardButton.isEnabled = (unit.levels.mediumLevel.progress == .complete)
//        chainsButton.isEnabled = (unit.levels.hardLevel.progress == .complete)
//    }
//    
//    func setColorForDisableBtn() {
//        for button in buttons {
//            if !button.isEnabled {
//                button.alpha = 0.5
//                button.backgroundColor = UIColor.disableButtonColor()
//            } else {
//                button.backgroundColor = UIColor.homeButtonColor()
//            }
//        }
//        
//    }
//    
//    func setDataCell() {
//        self.unitNumberLabel.text = unit.unitNumber
//        self.chapterNameLabel.text = unit.chapterName
//        self.easyLabel.text = unit.levels.easyLevel.title
//        self.mediumlabel.text = unit.levels.mediumLevel.title
//        self.hardLabel.text = unit.levels.hardLevel.title
//        self.chainsLabel.text = unit.levels.chainsLevel.title
//    }
//    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
//    
//    private func makeButtonRound() {
////        easyButton.layer.cornerRadius = buttonWidth / 2.0
////        mediumButton.layer.cornerRadius = buttonWidth / 2.0
////        chainsButton.layer.cornerRadius = buttonWidth / 2.0
////        hardButton.layer.cornerRadius = buttonWidth / 2.0
//    }
//    
//    func setProgressAnimation() {
//        removeProgressLayer(button: easyButton)
//        removeProgressLayer(button: mediumButton)
//        removeProgressLayer(button: hardButton)
//        removeProgressLayer(button: chainsButton)
//        setUpCircularProgressBarView(button: easyButton, progress: unit.levels.easyLevel.progress)
//        setUpCircularProgressBarView(button: mediumButton, progress: unit.levels.mediumLevel.progress)
//        setUpCircularProgressBarView(button: hardButton, progress: unit.levels.hardLevel.progress)
//        setUpCircularProgressBarView(button: chainsButton, progress: unit.levels.chainsLevel.progress)
//    }
//    
//    func setUpCircularProgressBarView(button: UIButton, progress: Progress) {
//        button.createCircularPath(duration: circularViewDuration, progress: progress, buttonWidth: buttonWidth)
//    }
//    
//    private func removeProgressLayer(button: UIButton) {
//        button.layer.sublayers?.forEach({ layer in
//            if layer is CAShapeLayer {
//                layer.removeFromSuperlayer()
//            }
//        })
//    }
//    
//    private func setFontsAndColor() {
////        unitNumberLabel.font = UIFont.headingFonts()
////        chapterNameLabel.font = UIFont.operatorViewCellFont()
////        easyLabel.font = UIFont.operatorViewCellFont()
////        mediumlabel.font = UIFont.operatorViewCellFont()
////        hardLabel.font = UIFont.operatorViewCellFont()
////        chainsLabel.font = UIFont.operatorViewCellFont()
////        easyButton.backgroundColor = UIColor.homeButtonColor()
////        mediumButton.backgroundColor = UIColor.homeButtonColor()
////        hardButton.backgroundColor = UIColor.homeButtonColor()
////        chainsButton.backgroundColor = UIColor.homeButtonColor()
////        tittleView.backgroundColor = UIColor.homeButtonColor()
////        easyButton.titleLabel?.font = UIFont.myAppBodyFonts()
////        mediumButton.titleLabel?.font = UIFont.myAppBodyFonts()
////        hardButton.titleLabel?.font = UIFont.myAppBodyFonts()
////        chainsButton.titleLabel?.font = UIFont.myAppBodyFonts()
//        
//    }
//}
//
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

//
//class PulsatingButton: UIButton {
//    let pulseLayer: CAShapeLayer = {
//        let shape = CAShapeLayer()
//        shape.strokeColor = UIColor.clear.cgColor
//        shape.lineWidth = 10
//        shape.fillColor = UIColor.white.withAlphaComponent(0.3).cgColor
//        shape.lineCap = .round
//        return shape
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupShapes()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupShapes()
//    }
//
//    fileprivate func setupShapes() {
//        setNeedsLayout()
//        layoutIfNeeded()
//
//        let backgroundLayer = CAShapeLayer()
//
//        let circularPath = UIBezierPath(arcCenter: self.center, radius: bounds.size.height/2, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
//
//        pulseLayer.frame = bounds
//        pulseLayer.path = circularPath.cgPath
//        pulseLayer.position = self.center
//        self.layer.addSublayer(pulseLayer)
//
//        backgroundLayer.path = circularPath.cgPath
//        backgroundLayer.lineWidth = 10
//        backgroundLayer.fillColor = UIColor.cyan.cgColor
//        backgroundLayer.lineCap = .round
//        self.layer.addSublayer(backgroundLayer)
//    }
//
//    func pulse() {
//        let animation = CABasicAnimation(keyPath: "transform.scale")
//        animation.toValue = 1.2
//        animation.duration = 1.0
//        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
//        animation.autoreverses = true
//        animation.repeatCount = .infinity
//        pulseLayer.add(animation, forKey: "pulsing")
//    }
//}


class OperatorTableViewCell: UITableViewCell {
    var buttonTappedAction: ((Int,LevelType) -> Void)?
    @IBOutlet weak var tittleView: UIView!
    @IBOutlet weak var unitNumberLabel: UILabel!
    @IBOutlet weak var chapterNameLabel: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    var currUnit: Int?
    private var buttons = [UIButton]()
    private var circularViewDuration: TimeInterval = 2


    override func awakeFromNib() {
        super.awakeFromNib()
    }
   
    private func removeProgressLayer() {
        buttons.forEach{ $0.layer.sublayers?.forEach({ layer in
            if layer is CAShapeLayer {
                layer.removeFromSuperlayer()
            }
        })
        }
    }
       
    
    func setDataCell(unit: Unit) {
        setFontsAndColor()
        removeProgressLayer()
        self.unitNumberLabel.text = unit.unitNumber
        self.chapterNameLabel.text = unit.chapterName
        
        stackView
            .arrangedSubviews
            .forEach { $0.removeFromSuperview() }
        
        var lastModel: LevelCellModel?
        var returnSingle = true
        unit.levels
            .compactMap { cellModel -> StackModelType? in
                if returnSingle {
                    returnSingle = !returnSingle
                    return .single(cellModel)
                } else {
                    if let model = lastModel {
                        lastModel = nil
                        returnSingle = !returnSingle
                        return .two(model, cellModel)
                    } else {
                        lastModel = cellModel
                        return nil
                    }
                }
            }
            .forEach { stackModelType -> Void in
                switch stackModelType {
                case .single(let model):
                    let singleButtonStackView = singleButtonStackView()
                    let levelView = addLevelViewFor(model: model)
                    singleButtonStackView.addArrangedSubview(levelView)
                    stackView.addArrangedSubview(singleButtonStackView)
                case .two(let model1, let model2):
                    let twoButtonStackView = twoButtonStackView()
                    let levelView = addLevelViewFor(model: model1)
                    twoButtonStackView.addArrangedSubview(levelView)
                    let levelView2 = addLevelViewFor(model: model2)
                    twoButtonStackView.addArrangedSubview(levelView2)
                    stackView.addArrangedSubview(twoButtonStackView)
                }
            }
    }
    
    private func setFontsAndColor() {
            unitNumberLabel.font = UIFont.headingFonts()
            chapterNameLabel.font = UIFont.operatorViewCellFont()
            tittleView.backgroundColor = UIColor.homeButtonColor()
    
       }
    
    func addLevelViewFor(model: LevelCellModel) -> LevelView {
        
        let levelView = levelView()
        levelView.button.tag = model.levelType.rawValue
        levelView.button.createCircularPath(duration: circularViewDuration, progress: model.progress, buttonWidth: buttonWidth)
        levelView.titleLabel.text = model.title
        levelView.button.setTitle(model.oprator.getOperator(), for: .normal)
        levelView.titleLabel.textColor = UIColor.bodyFontColor()
        return levelView
    }
    
    func levelView() -> LevelView {
        let levelView = LevelView(frame: CGRect(x: 0, y: 0, width: deviceWidth*25, height: deviceWidth*25+50))
        //levelView.backgroundColor = .yellow
        levelView.button.addTarget(self, action:  #selector(buttonTaped), for: .touchUpInside)
        levelView.button.backgroundColor = UIColor.homeButtonColor()
        levelView.titleLabel.font = UIFont.operatorViewCellFont()
        levelView.button.titleLabel?.font = UIFont.myAppBodyFonts()
        return levelView
    }
    
    @objc func buttonTaped(sender: UIButton) {
        buttonTappedAction!(currUnit!, LevelType(rawValue: sender.tag)!)
    }
    
    func singleButtonStackView() -> UIStackView {
        let containerStackView = UIStackView()
        containerStackView.axis = .horizontal
        containerStackView.alignment = .center
        containerStackView.spacing = deviceWidth * 0.25
        containerStackView.distribution = .equalCentering
        return containerStackView
    }
    
    func twoButtonStackView() -> UIStackView {
        let containerStackView = UIStackView()
        containerStackView.axis = .horizontal
        containerStackView.alignment = .center
        containerStackView.spacing = deviceWidth * 0.25
        containerStackView.distribution = .equalSpacing
        return containerStackView
    }
    
}

enum StackModelType {
    case single(LevelCellModel)
    case two(LevelCellModel, LevelCellModel)
}


class LevelView: UIView {
    var button: UIButton
    var titleLabel: UILabel
    
    override init(frame: CGRect) {
        self.button = LevelView.levelButton
        self.titleLabel = UILabel()
        super.init(frame: frame)
        
        
        self.addSubview(button)
        self.addSubview(titleLabel)
        
        // button
        button.translatesAutoresizingMaskIntoConstraints = false
        let leading = NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: button, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: titleLabel, attribute: .top, multiplier: 1, constant: 0)
        
        //        titleLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let titleLabelbottom = NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        
        let titleLabelCentre = NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: button, attribute: .centerX, multiplier: 1, constant: 0)
        
        
        NSLayoutConstraint.activate([leading, trailing, top, bottom, titleLabelbottom, titleLabelCentre])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var levelButton: UIButton {
        let button = UIButton()
        let constant = deviceWidth * 0.25
        button.heightAnchor.constraint(equalToConstant: CGFloat(constant)).isActive = true
        button.widthAnchor.constraint(equalToConstant: CGFloat(constant)).isActive = true
        //        button.setupShapes()
        //        button.pulse()
        button.btnCorner(cornerRadius: constant/2)
        return button
    }
}

var deviceWidth: CGFloat {
    return UIScreen.main.bounds.size.width
}

var buttonWidth: CGFloat {
    return deviceWidth*0.25
}
