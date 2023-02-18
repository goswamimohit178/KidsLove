//
//  OperatorsViewController.swift
//  KidsLove
//
//  Created by Vikash on 03/02/23.
//
//self.navigationController?.pushViewController(QuestionViewController(), animated: true)
import UIKit
import SwiftUI


final class OperatorsViewController: UIViewController {
    private var unitNameList = [Unit]()
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var operatorTableView: UITableView!
    @IBOutlet weak var myView: UIView!
    private var router: AppRouter!
    
    @IBOutlet weak var settingButton: UIButton!
    @IBAction func settingsButtonTapped(_ sender: Any) {
        router.showSettingsScreen()
    }
    
    private var model: SubjectModel!
    var currunit = 0
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        router = AppRouter(navigationController: navigationController!)
        let unitNameList = NetworkService().setLevelWise()
        self.model = SubjectModel(math: unitNameList)
        setButtonStyle()
        headerLabel.font = UIFont.myAppBodyFonts()
        operatorTableView.setShadow()
        operatorTableView.layer.cornerRadius = 0.05 * operatorTableView.bounds.size.width
    }
  
    private func setButtonStyle() {
        operatorTableView.dataSource = self
        operatorTableView.delegate = self
        operatorTableView.register(UINib(nibName: "OperatorTableViewCell", bundle: nil), forCellReuseIdentifier: "OperatorTableViewCell")
        myView.layer.cornerRadius = 0.05 * myView.bounds.size.width
        settingButton.titleLabel?.textColor = UIColor.bodyFontColor()
    }
    func setProgess(progress: Progress, unitNumber: Int,levelType: LevelType) {
//        switch levelType {
//        case .easy:
//            model.math[unitNumber].levels.easyLevel.progress = progress
//        case .medium:
//            model.math[unitNumber].levels.mediumLevel.progress = progress
//        case .hard:
//            model.math[unitNumber].levels.hardLevel.progress = progress
//        case .practice:
//            model.math[unitNumber].levels.chainsLevel.progress = progress
//        }
        operatorTableView.reloadData()
    }
    
}
extension OperatorsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.math.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = operatorTableView.dequeueReusableCell(withIdentifier: "OperatorTableViewCell") as! OperatorTableViewCell
        let unitModel = model.math[indexPath.row]
//        let chapterName = unitModel.chapterName
        cell.currUnit = indexPath.row
//        cell.unit = unitModel
//        cell.setDataCell()
//        cell.setTittleOperatorBtn(chapterName: chapterName)
//        cell.disableBtnForProgress(unit: unitModel)
//        cell.setColorForDisableBtn()
//        cell.setProgressAnimation()
        cell.buttonTappedAction = presentQuestionController
        cell.setDataCell(unit: unitModel)
        return cell
    }
    func presentQuestionController(unitNumber: Int, levelType: LevelType) {
        let questionVC = QuestionViewController()
        let cellModel = model.math[unitNumber].levels.first(where: { $0.levelType ==  levelType})
        questionVC.questionList = cellModel?.questions()
        questionVC.opratorVC = self
        questionVC.currentUnitNumber = unitNumber
        questionVC.currentLevelType = levelType
        navigationController?.pushViewController(questionVC, animated: true)
        
    }
    
    
    func showCurrentLevelQuestions(unitNumber: Int , leveltype: LevelType) {
        presentQuestionController(unitNumber: unitNumber, levelType: leveltype)
    }
    
    func showNextLevelQuestions(unitNumber: Int , leveltype: LevelType) {
        var newQue: [Question] = []
        switch leveltype {
            
        case .easy:
            newQue = model.math[unitNumber].levels.mediumLevel.questions()
        case .medium:
            newQue = model.math[unitNumber].levels.hardLevel.questions()
        case .hard:
            newQue = model.math[unitNumber].levels.chainsLevel.questions()
        case .practice:
            newQue = model.math[unitNumber].levels.chainsLevel.questions()
        }
        presentQuestionController(questions: newQue, levelType: leveltype, unitNumber: unitNumber)
    }
    
}
extension OperatorsViewController: UITableViewDelegate {
    
}
class CircularProgressBarView: UIView {
    
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func progressAnimation(duration: TimeInterval, progress: Progress) {
        // created circularProgressAnimation with keyPath
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        // set the end time
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 2
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}

extension UIView {
    
    func setShadow() {
        self.layer.shadowColor = UIColor.btnShadowColor().cgColor
        self.layer.shadowOffset = CGSize(width: 5.0, height: 10)
        self.layer.shadowOpacity = 3.0
        self.layer.shadowRadius = 5.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 20
        
    }
}

extension UIView {

  // OUTPUT 1
  func dropShadow(scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.5
    layer.shadowOffset = CGSize(width: -1, height: 1)
    layer.shadowRadius = 1

    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }

  // OUTPUT 2
  func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offSet
    layer.shadowRadius = radius

    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}
