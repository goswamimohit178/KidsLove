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
        setLevelWise()
        self.model = SubjectModel(math: unitNameList)
        setButtonStyle()
        headerLabel.font = UIFont.myAppBodyFonts()
        headerLabel.backgroundColor = UIColor.homeButtonColor()
    }
    
    private func setLevelWise() {
        
        let questionList: [Question] = [
            Question(questionText: "12 × 3 = ?", answer: [26,33,36,31], correctAnswer: 2),
         Question(questionText: "9 × 4 = ?", answer: [43,36,56,54], correctAnswer: 1),
         Question(questionText: "6 × 3 = ?", answer: [18,34,23,22], correctAnswer: 0),
         Question(questionText: "8 × 6 = ?", answer: [28,37,48,38], correctAnswer: 2)

     ]
        let mediumQuestionList: [Question] = [
            Question(questionText: "60 × 7 = ?", answer: [400,420,520,720], correctAnswer: 1),
            Question(questionText: "33 × 7 = ?", answer: [400,420,231,731], correctAnswer: 2),
            Question(questionText: "40 × 7 = ?", answer: [400,420,280,720], correctAnswer: 2),
            Question(questionText: "5 × 55 = ?", answer: [275,285,239,710], correctAnswer: 0)
        ]
        
        let hardQuestionList: [Question] =  [
            Question(questionText: "88 × 2 × 5 = ??", answer: [882,880,870,881], correctAnswer: 1),
            Question(questionText: "90 × 3 × 7 = ??", answer: [1882,1880,1890,1881], correctAnswer: 2),
            Question(questionText: "69 × 6 × 4 = ??", answer: [1682,1656,1670,1881], correctAnswer: 1),
            Question(questionText: "89 × 7 × 9 = ??", answer: [5601,5602,5607,5606], correctAnswer: 2)
            
        ]
        
        let easyLevelCellModel = LevelCellModel(title: "Easy", questions: questionList)
        let mediumLevelCellModel = LevelCellModel(title: "Medium", questions: mediumQuestionList)
        let hardLevelCellModel = LevelCellModel(title: "Hard", questions: hardQuestionList)
        let chainsLevelCellModel = LevelCellModel(title: "Chain", questions: [Question]())
        let roundingLevelCellModel = LevelCellModel(title: "Rounding", questions: [Question]())
        let reviewLevelCellModel = LevelCellModel(title: "Review", questions: [Question]())
        let level = Level(easyLevel: easyLevelCellModel,  hardLevel: hardLevelCellModel, mediumLevel: mediumLevelCellModel, chainsLevel: chainsLevelCellModel, roundingLevel: roundingLevelCellModel, reviewLevel: reviewLevelCellModel)
        
        unitNameList = [
            Unit(unitNumber: "Unit 1", chapterName: "Multiplication", levels: level),
            Unit(unitNumber: "Unit 2", chapterName: "Shapes", levels: level),
            Unit(unitNumber: "Unit 3", chapterName: "Division", levels: level),
            Unit(unitNumber: "Unit 4", chapterName: "Fractions", levels: level),
            Unit(unitNumber: "Unit 5", chapterName: "Measurement", levels: level),
            Unit(unitNumber: "Unit 6", chapterName: "Decimals", levels: level),
            Unit(unitNumber: "Unit 7", chapterName: "Review", levels: level)
        ]
        
    }
    
    private func setButtonStyle() {
        operatorTableView.dataSource = self
        operatorTableView.delegate = self
        operatorTableView.register(UINib(nibName: "OperatorTableViewCell", bundle: nil), forCellReuseIdentifier: "OperatorTableViewCell")
        myView.layer.cornerRadius = 0.05 * myView.bounds.size.width
        operatorTableView.layer.cornerRadius = 0.05 * operatorTableView.bounds.size.width
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
        cell.unitNumberLabel.text = unitModel.unitNumber
        cell.chapterNameLabel.text = unitModel.chapterName
        cell.easyLabel.text = unitModel.levels.easyLevel.title
        cell.mediumlabel.text = unitModel.levels.mediumLevel.title
        cell.hardLabel.text = unitModel.levels.hardLevel.title
        cell.chainsLabel.text = unitModel.levels.chainsLevel.title
        cell.roundingLabel.text = unitModel.levels.roundingLevel.title
        cell.reviewLabel.text = unitModel.levels.reviewLevel.title

        cell.setProgressAnimation()
        cell.buttonTappedAction = presentQuestionController
        
        return cell
    }
    func presentQuestionController(questions: [Question]) {
        let questionVC = QuestionViewController()
        questionVC.questionList = questions
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

enum Progress {
    case oneThird
    case twoThird
    case complete
    var progress: Float {
        switch self {
            
        case .oneThird:
            return 0.33
        case .twoThird:
            return 0.66
        case .complete:
            return 0.99
        }
    }
}
