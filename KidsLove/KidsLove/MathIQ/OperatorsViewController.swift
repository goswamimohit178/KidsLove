//
//  OperatorsViewController.swift
//  KidsLove
//
//  Created by Vikash on 03/02/23.
//
import UIKit
import SwiftUI
import GameKit

final class OperatorsViewController: UIViewController {
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var operatorTableView: UITableView!
    @IBOutlet weak var myView: UIView!
    private var router: AppRouter!
    
    @IBOutlet weak var settingButton: UIButton!
    @IBAction func settingsButtonTapped(_ sender: Any) {
        router.showSettingsScreen()
    }
    
    var model: SubjectModel!
    var currunit = 0
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUser()
        router = AppRouter(navigationController: navigationController!)
        setButtonStyle()
        headerLabel.font = UIFont.myAppBodyFonts()
        let appName = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as! String
        headerLabel.text = appName
        operatorTableView.setShadowAndCornerRadius(cornerRadius: 40)
        operatorTableView.layer.cornerRadius = 0.05 * operatorTableView.bounds.size.width
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func authenticateUser() {
        let player = GKLocalPlayer.local
        player.authenticateHandler = { vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            if let vc = vc {
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 10
       }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView(frame: .zero)
    }
    
    private func setButtonStyle() {
        operatorTableView.dataSource = self
        operatorTableView.delegate = self
        operatorTableView.register(UINib(nibName: "OperatorTableViewCell", bundle: nil), forCellReuseIdentifier: "OperatorTableViewCell")
        myView.layer.cornerRadius = 0.05 * myView.bounds.size.width
        settingButton.titleLabel?.textColor = UIColor.bodyFontColor()
    }
    
    func setProgess(progress: Progress, unitNumber: Int, levelNumber: Int) {
        switch model.math[unitNumber].levels[levelNumber].type {
        case .game(game: _):
            fatalError("Invalid state")
        case .math(progress: _, oprator: let oprator, noOfOprands: let noOfOprands, levelType: let levelType):
            model.math[unitNumber].levels[levelNumber].type = .math(progress: progress, oprator: oprator, noOfOprands: noOfOprands, levelType: levelType)
        }
        operatorTableView.reloadData()
    }
}

extension OperatorsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.math.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = operatorTableView.dequeueReusableCell(withIdentifier: "OperatorTableViewCell") as! OperatorTableViewCell
        cell.currUnit = indexPath.section
        cell.buttonTappedAction = presentQuestionController
        cell.setDataCell(unit: model.math[indexPath.section])
        return cell
    }
    func presentQuestionController(unitNumber: Int, levelNumber: Int) {
        navigationController?.tabBarController?.tabBar.isHidden = true
        let cellType = model.math[unitNumber].levels[levelNumber].type
        guard case .math(_, _, _, _) = cellType else {
            if case .game(let gameType) = cellType {
                switch gameType {
                case .TwoZeroFourEight:
                    let engine = GameEngine()
                    let storage = LocalStorage()
                    let stateTracker = GameStateTracker(initialState: (storage.board ?? engine.blankBoard, storage.score))
                    let vc = GameViewController(viewModel: GameViewModel(engine, storage: storage, stateTracker: stateTracker))
                    navigationController?.pushViewController(vc, animated: true)
                case .Mills:
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "GameVC")
                    navigationController?.pushViewController(rootViewController, animated: true)
                }
            }
            return
        }
        
        guard unitNumber <= model.math.count, levelNumber <= model.math[unitNumber].levels.count else {
            return
        }
        let questionVC = QuestionViewController()
        let cellModel = model.math[unitNumber].levels[levelNumber]
        questionVC.questionList = cellModel.questions()
        questionVC.opratorVC = self
        questionVC.currentUnitNumber = unitNumber
        questionVC.currentLevelNumber = levelNumber
        navigationController?.pushViewController(questionVC, animated: true)
    }
    
    func showQuestionsFor(unitNumber: Int, levelNumber: Int) {
        presentQuestionController(unitNumber: unitNumber, levelNumber: levelNumber)
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
    
    func setShadowAndCornerRadius(cornerRadius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = UIColor.btnShadowColor().cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 10.0
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
