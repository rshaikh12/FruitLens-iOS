//
//  ProfileCell.swift
//  FruitLens
//
//  Created by Emre Can Bolat on 07.06.20.
//  Copyright © 2020 ChristophWeber. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var countryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        name.text = ""
    }
    
    func setUser(_ user: ObjectUser?) {
        if let user = user {
            self.name.text = user.name ?? user.email
            self.countryName.text = "Deutschland"
        }
    }
    
    @IBAction func editProfile(_ sender: UIButton) {
    }
}
