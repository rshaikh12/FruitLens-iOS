//
//  ProfileController.swift
//  FruitLens
//
//  Created by Emre Can Bolat on 07.06.20.
//  Copyright © 2020 ChristophWeber. All rights reserved.
//

import UIKit


class ProfileController: UIViewController {
    
    var tableInformationSettings: [(UIColor, UIColor, String)] = [
            (UIColor(red: 129/255, green: 190/255, blue: 62/255, alpha: 1.0), .white, "Konfigurationen"),
            (UIColor(red: 224/255, green: 174/255, blue: 24/255, alpha: 1.0), .white, "")
        ]
    
    var tableInformationProfile: [(UIColor, UIColor, String)] = [
        (UIColor(red: 129/255, green: 190/255, blue: 62/255, alpha: 1.0), .white, "Heute"),
        (UIColor(red: 224/255, green: 174/255, blue: 24/255, alpha: 1.0), .white, "Diese Woche"),
        (UIColor(red: 133/255, green: 29/255, blue: 235/255, alpha: 1.0), .white, "Dieser Monat"),
        (UIColor(red: 129/255, green: 190/255, blue: 62/255, alpha: 1.0), .white, "Dieses Jahr"),
        (UIColor(red: 224/255, green: 174/255, blue: 24/255, alpha: 1.0), .white, "Gesamt"),
        ]
    
    @IBOutlet var profileTable: CustomTableView!
    @IBOutlet var settingsTable: CustomTableView!

    @IBOutlet weak var profileHeader: UIView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileHeaderConstant: NSLayoutConstraint!
    
    var processedFoods: [Food] = []
    var processedFoodValues: [([Food], Int)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.profileName.text = Config.currentUser?.name ?? Config.currentUser?.email
        buildValues()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if let ratio = self.profileTable?.contentOffsetRatio {
            coordinator.animate(alongsideTransition: { (context) in
                self.profileTable?.determineNewContentOffsetForRatio(ratio: ratio)
            }, completion: nil)
        }
    }
    
    @IBAction func valueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            profileTable.isHidden = false
            settingsTable.isHidden = true
        default:
            profileTable.isHidden = true
            settingsTable.isHidden = false
            break;
        }
        profileTable.reloadData()
        settingsTable.reloadData()
    }
    
    func buildValues() {
        self.processedFoods = Food.getAll()
        
        let today = Date()
        
        let yearValues: [Food] = self.processedFoods.filter { (food) -> Bool in
            food.timestamp >= today.startOfYear.millisecondsSince1970 &&
                food.timestamp <= today.endOfYear.millisecondsSince1970
        }
        
        let monthValues: [Food] = yearValues.filter { (food) -> Bool in
            food.timestamp >= today.startOfMonth.millisecondsSince1970 &&
                food.timestamp <= today.endOfMonth.millisecondsSince1970
        }
        
        let weekValues: [Food] = monthValues.filter { (food) -> Bool in
            food.timestamp >= today.startOfWeek.millisecondsSince1970 &&
                food.timestamp <= today.endOfWeek.millisecondsSince1970
        }
        
        let todaysValues: [Food] = weekValues.filter { (food) -> Bool in
            food.timestamp >= today.startOfDay.millisecondsSince1970 &&
                food.timestamp <= today.endOfDay.millisecondsSince1970
        }
        
        self.processedFoodValues = [
            ( todaysValues, todaysValues.reduce(0) {res, food in res + Int(food.fructose_value)} ),
            ( weekValues, weekValues.reduce(0) {res, food in res + Int(food.fructose_value)} ),
            ( monthValues, monthValues.reduce(0) {res, food in res + Int(food.fructose_value)} ),
            ( yearValues, yearValues.reduce(0) {res, food in res + Int(food.fructose_value)} ),
            ( processedFoods, processedFoods.reduce(0) {res, food in res + Int(food.fructose_value)} ),
        ]
        if let profileTable = profileTable {
            profileTable.reloadData()
        }
    }
}

extension ProfileController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        return string.rangeOfCharacter(from: invalidCharacters) == nil
    }
}

extension ProfileController: UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.profileTable {
            return 6
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.profileTable {
            return 1
        } else {
            if section == 1 {
                return 2
            } else if section == 2 || section == 0 {
                return 1
            }
        }
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !scrollView.isDragging {
            return
        }

        if profileHeaderConstant.constant - scrollView.contentOffset.y <= UIScreen.main.bounds.height,
            profileHeaderConstant.constant - scrollView.contentOffset.y >= 100 {
            profileHeaderConstant.constant = profileHeaderConstant.constant - scrollView.contentOffset.y
        } else {
            if UIScreen.main.bounds.height.distance(to: profileHeaderConstant.constant) > profileHeaderConstant.constant.distance(to: 200) {
                profileHeaderConstant.constant = UIScreen.main.bounds.height
            } else {
                profileHeaderConstant.constant = 100
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        profileHeaderConstant.constant = profileHeaderConstant.constant > 200.0 ?
            200 : profileHeaderConstant.constant
        
        if profileHeaderConstant.constant >= 200 {
            profileTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            settingsTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        let profile = tableView.dequeueReusableCell(withIdentifier: "profile")!
        
        if indexPath.row == 0, indexPath.section == 0 {
            cell = profile
            (cell as! ProfileCell).setUser(Config.getCurrentUser())
        }
        
        if cell == nil {
            if tableView == self.profileTable {
                cell = self.defineCellForFirstTable(tableView, cellForRowAt: indexPath)
            } else if tableView == self.settingsTable {
                cell = self.defineCellForThirdTable(tableView, cellForRowAt: indexPath)
            }
        }
        
        return cell!
    }
    
    private func defineCellForFirstTable(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        let normal = tableView.dequeueReusableCell(withIdentifier: "normal") as! SettingsCell
        let progress = tableView.dequeueReusableCell(withIdentifier: "progress") as! ProgressCell
        let progress2 = tableView.dequeueReusableCell(withIdentifier: "progress2") as! ProgressCell
        
        switch indexPath.section {
            case 1, 2, 3, 4, 5:
                
                let days = indexPath.section == 1 ? 1 : indexPath.section == 2 ? 7 : indexPath.section == 3 ? 30 :
                indexPath.section == 4 ? 365 : 0
                
                cell = days != 0 && Config.hasDailyLimitSet() ? progress2 : progress
                
                (cell as! ProgressCell).setValues(self.processedFoodValues[indexPath.section - 1],
                                                  days: days)
            default:
                cell = normal
        }
        
        return cell
    }
    
    private func defineCellForThirdTable(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        let normal = tableView.dequeueReusableCell(withIdentifier: "normal") as! SettingsCell
        
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                cell = normal
                normal.setText("Daily limit", isSwitch: true)
                normal.switchButton?.isOn = Config.hasDailyLimitSet()
                normal.switchHandler = {
                    Config.setHasDailyLimit(normal.switchButton?.isOn ?? false)
                    tableView.reloadData()
                }
            case 1:
                cell = normal
                normal.setTextField("Daily limit value")
                normal.textField?.keyboardType = .numberPad
                normal.textField?.text = "\(Config.getDailyLimit())"
                normal.textField?.isEnabled = Config.hasDailyLimitSet()
                normal.textField?.delegate = self
                normal.textField?.enablesReturnKeyAutomatically = true
                
                normal.textFieldHandler = {
                    Config.setDailyLimit(Int(normal.textField?.text ?? "0")!)
                }
            default:
                cell = normal
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                cell = normal
                normal.setText("Abmelden")
            default:
                cell = normal
                break
            }
        default:
            cell = normal
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.settingsTable {
            self.selectRowForThirdTable(didSelectRowAt: indexPath, tableView)
        }
    }
    
    func selectRowForThirdTable(didSelectRowAt indexPath: IndexPath, _ tableView: UITableView) {
        
        switch indexPath.section {
        case 2:
            switch indexPath.row {
            case 0:
                NotificationCenter.default.post(name: .logoutRequest, object: nil)
            default:
                break
            }
        default:
            break
        }
    }
}

extension ProfileController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView(frame: .zero)
        }
        
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 32))
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: view.frame.size.width, height: 32))
        returnedView.addSubview(label)
        
        
        if tableView == self.profileTable {
            returnedView.backgroundColor = tableInformationProfile[section - 1].0
            label.textColor = tableInformationProfile[section - 1].1
            label.text = tableInformationProfile[section - 1].2
        } else {
            returnedView.backgroundColor = tableInformationSettings[section - 1].0
            label.textColor = tableInformationSettings[section - 1].1
            label.text = tableInformationSettings[section - 1].2
        }
        
        return returnedView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? .leastNormalMagnitude : 32
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(red: 111/255, green: 113/255, blue: 121/255, alpha: 1)
        return view
    }
    
}
