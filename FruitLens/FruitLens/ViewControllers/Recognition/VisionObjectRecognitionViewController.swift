//
//  VisionObjectRecognitionViewController.swift
//  FruitLens
//
//  Created by Christoph Weber on 18.05.20.
//


import UIKit
import AVFoundation
import Vision

class VisionObjectRecognitionViewController: ViewController {
    
    private var detectionOverlay: CALayer! = nil
    private var detectedFood: (String, Float64, UIImage?)?
    private var requests = [VNRequest]()
    
    let fruitsData = DataLoader().fruitsData

    
    private var fruit = ""
    private var fructose = 0.0
    
    @discardableResult
    func setupVision() -> NSError? {
        // Setup Vision parts
        let error: NSError! = nil
        
        guard let modelURL = Bundle.main.url(forResource: "Resnet50", withExtension: "mlmodelc") else {
            print("Model file is missing")
            return NSError(domain: "VisionObjectRecognitionViewController", code: -1, userInfo: [NSLocalizedDescriptionKey: "Model file is missing"])
        }
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                DispatchQueue.main.async(execute: {
                    // perform all the UI updates on the main queue
                    if let results = request.results {
                        self.displayLabel(results)
                    }
                })
            })
            self.requests = [objectRecognition]
        } catch let error as NSError {
            print("Model loading went wrong: \(error)")
        }
        
        return error
        
    }
    
    func displayLabel(_ results: [Any]) {
        guard let result = results as? [VNClassificationObservation]
            else {return}
        guard let firstObservation = result.first
            else {return}
                    
        
        var fructose: Float64? = 0.0
        var existing = false
        self.label.text = ""
        
        for f in fruitsData {
            if f.fruits_name == firstObservation.identifier{
                fructose = f.fruit_fructose * f.fruit_weight_mean
                existing = true
                self.detectedFood = (f.fruits_name, fructose!, nil)
                self.label.text = firstObservation.identifier

            }
        }
        if let eatButton = eatButton {
            eatButton.isHidden = !existing
        }
    }

    
    override func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let exifOrientation = exifOrientationFromDeviceOrientation()
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exifOrientation, options: [:])
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
    
    override func setupAVCapture() {
        super.setupAVCapture()
        // setup Vision parts
        setupVision()
        
        // start the capture
        startCaptureSession()
    }
    
    
    @IBAction override func eatFruit(_ sender: UIButton){
        let alert = UIAlertController(title: "Fruit Detected", message: "Die folgende Frucht wurde erkannt: " + self.detectedFood!.0, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Hinzufügen", style: .default, handler: addToDB))
        alert.addAction(UIAlertAction(title: "Verwerfen", style: .cancel, handler: nil))
//        alert.addAction(UIAlertAction(title: "Tagebucheintrag erstellen", style: .default, handler: createJournalEntry))
        self.present(alert, animated: true)

    }
    
    func createJournalEntry(alert: UIAlertAction!){
        fruit = self.detectedFood!.0
        fructose = self.detectedFood!.1
        performSegue(withIdentifier: "noteSegue", sender: self)
        DatabaseInserter.addFood(name: self.detectedFood!.0, fructoseValue: self.detectedFood!.1)
    }
    
    func addToDB(alert: UIAlertAction!){
        DatabaseInserter.addFood(name: self.detectedFood!.0, fructoseValue: self.detectedFood!.1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! CreateChangeViewController
        vc.noteTitleTextField.text = self.detectedFood!.0
    }
}
