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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var unitNameList = NetworkService().setLevelWise()
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
        cell.unit = unitModel
        cell.setDataCell()
        cell.setProgressAnimation()
        cell.buttonTappedAction = presentQuestionController
        return cell
    }
    func presentQuestionController(questions: [Question], levelType: LevelType) {
        let questionVC = QuestionViewController()
        questionVC.questionList = questions
        questionVC.opratorVC = self
        
        questionVC.currentUnitNumber = 0
        questionVC.currentLevelType = levelType
        navigationController?.pushViewController(questionVC, animated: true)
        
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


