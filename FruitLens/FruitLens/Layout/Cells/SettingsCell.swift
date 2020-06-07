//
//  SettingsCell.swift
//  FruitLens
//
//  Created by Emre Can Bolat on 07.06.20.
//  Copyright © 2020 ChristophWeber. All rights reserved.
//

import Foundation
import UIKit

class SettingsCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var switchButton: UISwitch?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        icon.image = nil
        label.text = ""
        switchButton?.isHidden = true
        selectionStyle = .blue
    }
    
    func setText(_ text: String, isSwitch: Bool = false) {
        DispatchQueue.main.async {
            self.label.text = text
            self.switchButton?.isHidden = !isSwitch
            
            if isSwitch {
                self.selectionStyle = .none
            }
        }
    }

}
