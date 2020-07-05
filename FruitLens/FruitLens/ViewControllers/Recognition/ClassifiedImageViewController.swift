//
//  ClassifiedImageView.swift
//  FruitLens
//
//  Created by admin on 29.06.20.
//  Copyright © 2020 ChristophWeber. All rights reserved.
//

import Foundation

import UIKit
import AVFoundation
import Vision

class ClassifiedImageViewController: VisionObjectRecognitionViewController {
    //IBOutlets
    @IBOutlet weak var capturedImageView: UIImageView!
    @IBOutlet weak var classificationLabel: UILabel!
    @IBOutlet weak var manualClassification: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var retryButton: UIButton!
    
    public var food: (String, Float64, UIImage?)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let food = self.food {
            self.classificationLabel.text = food.0
        }
    }
    
    @IBAction func eatFood(_ sender: UIButton) {
        DatabaseInserter.addFood(name: food!.0, fructoseValue: food!.1)
        self.dismiss(animated: true)
    }
    
    @IBAction func retunToCameraScreen(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func updateLabel(_ sender: Any) {
        //todo
    }
    
}
