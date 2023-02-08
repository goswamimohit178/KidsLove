//
//  OperatorsViewController.swift
//  KidsLove
//
//  Created by Vikash on 03/02/23.
//
//self.navigationController?.pushViewController(QuestionViewController(), animated: true)
import UIKit


final class OperatorsViewController: UIViewController {
    private var unitNameList = [UnitModel]()
    @IBOutlet weak var operatorTableView: UITableView!
    @IBOutlet weak var myView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonStyle()
       
    }
    
    private func setButtonStyle() {
        operatorTableView.dataSource = self
        operatorTableView.delegate = self
        operatorTableView.register(UINib(nibName: "OperatorTableViewCell", bundle: nil), forCellReuseIdentifier: "OperatorTableViewCell")
        myView.layer.cornerRadius = 0.05 * myView.bounds.size.width
        operatorTableView.layer.cornerRadius = 0.05 * operatorTableView.bounds.size.width
        
        
         unitNameList = [
           UnitModel(unitNumber: "Unit 1", chapterName: "Multiplication", easyLabel: "Easy", mediumlabel: "Medium", hardLabel: "Hard", chainsLabel: "Chains", roundingLabel: "Rounding", reviewLabel: "Review"),
           UnitModel(unitNumber: "Unit 2", chapterName: "Shapes", easyLabel: "Area", mediumlabel: "Perimeter", hardLabel: "Units", chainsLabel: "Angles", roundingLabel: "Parallel", reviewLabel: "Review"),
           UnitModel(unitNumber: "Unit 3", chapterName: "Division", easyLabel: "Easy", mediumlabel: "Medium", hardLabel: "Hard", chainsLabel: "Chains", roundingLabel: "Rounding", reviewLabel: "Review"),
           UnitModel(unitNumber: "Unit 4", chapterName: "Fractions", easyLabel: "Easy", mediumlabel: "Medium", hardLabel: "Hard", chainsLabel: "Chains", roundingLabel: "Rounding", reviewLabel: "Review"),
           UnitModel(unitNumber: "Unit 5", chapterName: "Measurement", easyLabel: "Easy", mediumlabel: "Medium", hardLabel: "Hard", chainsLabel: "Chains", roundingLabel: "Rounding", reviewLabel: "Review"),
           UnitModel(unitNumber: "Unit 6", chapterName: "Decimals", easyLabel: "Easy", mediumlabel: "Medium", hardLabel: "Hard", chainsLabel: "Chains", roundingLabel: "Rounding", reviewLabel: "Review"),
           UnitModel(unitNumber: "Unit 7", chapterName: "Review", easyLabel: "Easy", mediumlabel: "Medium", hardLabel: "Hard", chainsLabel: "Chains", roundingLabel: "Rounding", reviewLabel: "Review")
        ]
    
    }
    
}
extension OperatorsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unitNameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = operatorTableView.dequeueReusableCell(withIdentifier: "OperatorTableViewCell") as! OperatorTableViewCell
        let model = unitNameList[indexPath.row]
        cell.unitNumberLabel.text = model.unitNumber
        cell.chapterNameLabel.text = model.chapterName
        cell.easyLabel.text = model.easyLabel
        cell.mediumlabel.text = model.mediumlabel
        cell.hardLabel.text =  model.hardLabel
        cell.chainsLabel.text = model.chainsLabel
        cell.roundingLabel.text = model.roundingLabel
        cell.setProgressAnimation()
        cell.buttonTappedAction = presentQuestionController
        
        return cell
    }
    func presentQuestionController() {
        navigationController?.pushViewController(QuestionViewController(), animated: true)
    }
   
}
extension OperatorsViewController: UITableViewDelegate {
    
}

struct UnitModel {
    let unitNumber: String
    let chapterName: String
    let easyLabel: String
    let mediumlabel: String
    let hardLabel: String
    let chainsLabel: String
    let roundingLabel: String
    let reviewLabel: String
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
            circularProgressAnimation.toValue = 1
            circularProgressAnimation.fillMode = .forwards
            circularProgressAnimation.isRemovedOnCompletion = false
            progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}

enum Progress {
    case oneThird
    case twoThird
    case complete
}
