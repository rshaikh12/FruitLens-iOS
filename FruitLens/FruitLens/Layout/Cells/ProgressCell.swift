//
//  ProgressCell.swift
//  FruitLens
//
//  Created by Emre Can Bolat on 07.06.20.
//  Copyright © 2020 ChristophWeber. All rights reserved.
//

import UIKit

class ProgressCell: UITableViewCell {

    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progresView: CustomProgressView!
    @IBOutlet weak var fructoseCount: UILabel!
    @IBOutlet weak var ateCount: UILabel!
    @IBOutlet weak var capturedCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        progressLabel.text = "0%"
    }
    
    func setValues(_ value: ([Food], Int)) {
        DispatchQueue.main.async {
            self.fructoseCount.text = String(value.1) + "g"
            self.ateCount.text = String(value.0.count)
            
            let percentage = 0
            self.progressLabel.text = "\(String(format:"%.02f", percentage * 100))%"
            self.progresView.progress = Float(percentage)
        }
    }
}
