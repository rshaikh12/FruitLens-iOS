//
//  ClassifiedImageViewController.swift
//  FruitLens
//
//  Created by admin on 09.06.20.
//  Copyright © 2020 ChristophWeber. All rights reserved.
//

import UIKit
import GRDB

class ClassifiedImageViewController: UIViewController, VisionObjectRecognitionViewController {
    
    var detectedFood: [Food]
    var fructoseValue: Int64
    @IBOutlet weak var capturedImage: UIImageView
    @IBOutlet weak var classification_label: UILabel
    @IBOutlet weak var manual_classification:
    UITextField
    

    override func viewDidLoad() {
        super.viewDidLoad()
        capturedImage = stillImageOutput

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addToDatabase(result: String){
        fructoseValue = determineFructoseValue(result)
        
        
    }
    
    @IBAction func returnToCameraScreen(){
        
    }
    
    func determineFructoseValue(Fruit: String){
        
    }
    
   
    
   

}
