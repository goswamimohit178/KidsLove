//
//  OperatorTableViewCell.swift
//  KidsLove
//
//  Created by Vikash on 07/02/23.
//

import UIKit

class OperatorTableViewCell: UITableViewCell {
    var buttonTappedAction: ((Int,Int) -> Void)?
    @IBOutlet weak var tittleView: UIView!
    @IBOutlet weak var unitNumberLabel: UILabel!
    @IBOutlet weak var chapterNameLabel: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    var currUnit: Int?
    private var buttons = [UIButton]()
    private var circularViewDuration: TimeInterval = 2
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.defaultThemeColor.cgColor
        self.layer.borderWidth = bounds.width * 0.025
//        setShadowAndCornerRadius(cornerRadius: bounds.width * 0.01)
    }
    
    private func removeProgressLayer() {
        buttons.forEach{ $0.layer.sublayers?.forEach({ layer in
            if layer is CAShapeLayer {
                layer.removeFromSuperlayer()
            }
        })
        }
    }
    
    func disableBtnForProgress(unit: Unit) {
        for (index, level) in unit.levels.enumerated() {
            switch level.type {
            case .game(_):
                return
            case .math(progress: _, oprator: _, noOfOprands: _, levelType: let levelType):
                let isEnabled = (levelType == .easy) || (unit.levels[index-1].type.mathProgress == .complete)
                buttons[index].isEnabled = isEnabled
                if isEnabled {
                    buttons[index].backgroundColor = UIColor.homeButtonColor()
                    buttons[index].alpha = 1.0
                } else {
                    buttons[index].alpha = 0.5
                    buttons[index].backgroundColor = UIColor.disableButtonColor()
                }
            }
        }
    }
    
    func setDataCell(unit: Unit) {
        buttons = [UIButton]()
        setFontsAndColor()
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
        disableBtnForProgress(unit: unit)
    }
    
    private func setFontsAndColor() {
        unitNumberLabel.font = UIFont.headingFonts()
        chapterNameLabel.font = UIFont.operatorViewCellFont()
        tittleView.backgroundColor = UIColor.homeButtonColor()
//        tittleView.setShadowAndCornerRadius(cornerRadius: 40)
    }
    
    func addLevelViewFor(model: LevelCellModel) -> LevelView {
        let levelView = levelView()
        levelView.titleLabel.text = model.title
        levelView.titleLabel.textColor = UIColor.bodyFontColor()
        guard case .math(let progress, let oprator, _, let levelType) = model.type else {
            if case .game(let gameType) = model.type{
                levelView.button.tag =  model.type.index
                levelView.button.setTitle(gameType.title, for: .normal)
            }
            return levelView
        }
        levelView.button.setTitle(oprator.getOperator(), for: .normal)
        levelView.button.createCircularPath(duration: circularViewDuration, progress: progress, buttonWidth: buttonWidth)
        levelView.button.tag = levelType.rawValue
        return levelView
    }
    
    func levelView() -> LevelView {
        let levelView = LevelView(frame: .zero)
        levelView.heightAnchor.constraint(equalToConstant: CGFloat(buttonWidth+50)).isActive = true
        levelView.widthAnchor.constraint(equalToConstant: CGFloat(buttonWidth)).isActive = true
        levelView.button.addTarget(self, action:  #selector(buttonTaped), for: .touchUpInside)
        levelView.button.backgroundColor = UIColor.homeButtonColor()
        levelView.titleLabel.font = UIFont.operatorViewCellFont()
        levelView.button.titleLabel?.font = UIFont.myAppBodyFonts()
        buttons.append(levelView.button)
        return levelView
    }
    
    @objc func buttonTaped(sender: UIButton) {
        buttonTappedAction!(currUnit!, sender.tag)
    }
    
    func singleButtonStackView() -> UIStackView {
        let containerStackView = UIStackView()
        containerStackView.axis = .horizontal
        containerStackView.alignment = .center
        containerStackView.spacing = buttonWidth
        containerStackView.distribution = .equalCentering
        return containerStackView
    }
    
    func twoButtonStackView() -> UIStackView {
        let containerStackView = UIStackView()
        containerStackView.axis = .horizontal
        containerStackView.alignment = .center
        containerStackView.spacing = buttonWidth
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
        let top = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: titleLabel, attribute: .top, multiplier: 1, constant: -20)
        
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
        let constant = buttonWidth
        button.heightAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.btnCorner(cornerRadius: constant/2)
        return button
    }
}

var deviceWidth: CGFloat {
    return UIScreen.main.bounds.size.width
}

var buttonWidth: CGFloat {
    return min(max(deviceWidth*0.25, 100), 200)
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
        progressLayer.lineCap = .butt
        progressLayer.fillRule = .evenOdd
        progressLayer.lineWidth = buttonWidth * 0.50
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.rightAnswerColor().cgColor
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
