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
    
    @IBAction func addToDatabase(_ sender: UIButton) {
        //todo
    }
    
    @IBAction func retunToCameraScreen(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func updateLabel(_ sender: Any) {
        //todo
    }
    
}
