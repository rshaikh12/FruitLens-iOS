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
    
    var switchHandler: () -> () = { }
    var textFieldHandler: () -> () = { }
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var switchButton: UISwitch?
    @IBOutlet weak var textField: UITextField?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // icon.image = nil
        label.text = ""
        switchButton?.isHidden = true
        textField?.isHidden = true
        selectionStyle = .blue
    }
    
    func setText(_ text: String, isSwitch: Bool = false) {
        DispatchQueue.main.async {
            self.label.text = text
            self.switchButton?.isHidden = !isSwitch
            self.textField?.isHidden = true
            if isSwitch {
                self.selectionStyle = .none
            }
        }
    }
    
    func setTextField(_ text: String) {
        DispatchQueue.main.async {
            self.label.text = text
            self.switchButton?.isHidden = true
            self.selectionStyle = .none
            self.textField?.isHidden = false
        }
    }
    
    @IBAction func pushSwitch(_ sender: UISwitch) {
        switchHandler()
    }

    @IBAction func endEditText(_ sender: UITextField) {
        textFieldHandler()
    }
}
