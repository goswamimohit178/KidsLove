//
//  OperatorsViewController.swift
//  KidsLove
//
//  Created by Vikash on 03/02/23.
//
//self.navigationController?.pushViewController(QuestionViewController(), animated: true)
import UIKit


final class OperatorsViewController: UIViewController {
    private var unitNameList = [Unit]()
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var operatorTableView: UITableView!
    @IBOutlet weak var myView: UIView!
    
    private var model: SubjectModel!
    var currunit = 0
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        let unitNameList = NetworkService().setLevelWise()
        self.model = SubjectModel(math: unitNameList)
        setButtonStyle()
        headerLabel.font = UIFont.myAppBodyFonts()
        headerLabel.backgroundColor = UIColor.homeButtonColor()
    }
  
    private func setButtonStyle() {
        operatorTableView.dataSource = self
        operatorTableView.delegate = self
        operatorTableView.register(UINib(nibName: "OperatorTableViewCell", bundle: nil), forCellReuseIdentifier: "OperatorTableViewCell")
        myView.layer.cornerRadius = 0.05 * myView.bounds.size.width
        operatorTableView.layer.cornerRadius = 0.05 * operatorTableView.bounds.size.width
    }
    func setProgess(progress: Progress, unitNumber: Int,levelType: LevelType) {
        switch levelType {
        case .easy:
            model.math[unitNumber].levels.easyLevel.progress = progress
        case .medium:
            model.math[unitNumber].levels.mediumLevel.progress = progress
        case .hard:
            model.math[unitNumber].levels.hardLevel.progress = progress
        case .practice:
            model.math[unitNumber].levels.chainsLevel.progress = progress
        }
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
        let chapterName = unitModel.chapterName
        cell.currUnit = indexPath.row
        cell.unit = unitModel
        cell.setDataCell()
        cell.setTittleOperatorBtn(chapterName: chapterName)
        cell.disableBtnForProgress(unit: unitModel)
        cell.setColorForDisableBtn()
        cell.setProgressAnimation()
        cell.buttonTappedAction = presentQuestionController
        return cell
    }
    func presentQuestionController(questions: [Question], levelType: LevelType , unitNumber: Int) {
        let questionVC = QuestionViewController()
        questionVC.questionList = questions
        questionVC.opratorVC = self
        questionVC.currentUnitNumber = unitNumber
        questionVC.currentLevelType = levelType
        navigationController?.pushViewController(questionVC, animated: true)
        
    }
    
    
    func showCurrentLevelQuestions(unitNumber: Int , leveltype: LevelType) {
        var newQue: [Question] = []
        switch leveltype {
            
        case .easy:
            newQue = model.math[unitNumber].levels.easyLevel.questions()
        case .medium:
            newQue = model.math[unitNumber].levels.mediumLevel.questions()
        case .hard:
            newQue = model.math[unitNumber].levels.hardLevel.questions()
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


