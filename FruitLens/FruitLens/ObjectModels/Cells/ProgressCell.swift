//
//  ProgressCell.swift
//  FruitLens
//
//  Created by Emre Can Bolat on 07.06.20.
//  Copyright © 2020 Emre Can Bolat. All rights reserved.
//

import UIKit

class ProgressCell: UITableViewCell {

    @IBOutlet weak var progressLabel: UILabel?
    @IBOutlet weak var progresView: CustomProgressView?
    @IBOutlet weak var fructoseCount: UILabel!
    @IBOutlet weak var ateCount: UILabel!
    @IBOutlet weak var capturedCount: UILabel!
    @IBOutlet weak var divider: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        progressLabel?.text = "0%"
    }
    
    override func prepareForReuse() {
        self.fructoseCount.text = "0g"
        self.ateCount.text = "0"
        self.progressLabel?.text = "0%"
        self.progressLabel?.isHidden = false
        self.progresView?.isHidden = false;
        self.divider?.isHidden = false
    }
    
    func setValues(_ value: ([Food], Int), days: Int) {
        DispatchQueue.main.async {
            self.fructoseCount.text = String(value.1) + "g"
            self.ateCount.text = String(value.0.count)
            
            if Config.hasDailyLimitSet(), Config.getDailyLimit() > 0, days != 0 {
                let percentage = (Float(value.1) / Float(Config.getDailyLimit() * days))
                self.progressLabel?.text = "\(String(format:"%.02f", percentage * 100))%"
                self.progresView?.progress = Float(percentage)
                
                self.progressLabel?.isHidden = false
                self.progresView?.isHidden = false;
                self.divider?.isHidden = false
            } else {
                self.progressLabel?.isHidden = true
                self.progresView?.isHidden = true;
                self.divider?.isHidden = true
            }
        }
    }
}
