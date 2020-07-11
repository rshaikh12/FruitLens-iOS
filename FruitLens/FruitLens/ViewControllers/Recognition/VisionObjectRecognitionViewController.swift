//
//  VisionObjectRecognitionViewController.swift
//  FruitLens
//
//  Created by Christoph Weber on 18.05.20.
//  Copyright © 2020 ChristophWeber. All rights reserved.
//


import UIKit
import AVFoundation
import Vision

class VisionObjectRecognitionViewController: ViewController {
    
    private var detectionOverlay: CALayer! = nil
    private var detectedFood: (String, Float64, UIImage?)?
    private var requests = [VNRequest]()
    
    var fruit = ""
    var fructose = 0.0
    
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
                        //self.drawVisionRequestResults(results)
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
            
        let dictionary: [String?: Float64] = ["Banana": 123.0, "lemon":12.0]
        
        
        let data = DataLoader().fruitsData
        //print(data)
        
            
        var fructose: Float64? = 0.0
        var existing = false
        
        for fruit in dictionary.keys {
            if fruit == firstObservation.identifier{
                fructose = dictionary[firstObservation.identifier]
                existing = true
                self.detectedFood = (firstObservation.identifier, fructose!, nil)
            }
        }
            
            if let eatButton = eatButton {
                eatButton.isHidden = !existing
            }
            
        self.label.text = firstObservation.identifier
            
            
            
        
        
        
    }
    
    func drawVisionRequestResults(_ results: [Any]) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        detectionOverlay.sublayers = nil // remove all the old recognized objects
        
        if let eatButton = eatButton {
            eatButton.isHidden = true
        }
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                continue
            }
            
            // Select only the label with the highest confidence.
            let topLabelObservation = objectObservation.labels[0]
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(bufferSize.width), Int(bufferSize.height))
            let shapeLayer = self.createRoundedRectLayerWithBounds(objectBounds)


            //dummy dict as database substitute - to be changed
            let dictionary: [String?: Float64] = ["Banana": 123.0, "Egg":12.0]
            
            var fructose: Float64? = 0.0
            var existing = false
            for fruit in dictionary.keys {
                if fruit == topLabelObservation.identifier{
                    fructose = dictionary[topLabelObservation.identifier]
                    existing = true
                    self.detectedFood = (topLabelObservation.identifier, fructose!, nil)
                }
            }
            
            let textLayer = self.createTextSubLayerInBounds(objectBounds,
                                                            identifier: topLabelObservation.identifier,
                                                            confidence: topLabelObservation.confidence,
                                                            fructose: fructose ?? 0.0)
            shapeLayer.addSublayer(textLayer)
            detectionOverlay.addSublayer(shapeLayer)
            if let eatButton = eatButton {
                eatButton.isHidden = !existing
            }
        }
        self.updateLayerGeometry()
        CATransaction.commit()
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
        setupLayers()
        updateLayerGeometry()
        setupVision()
        
        // start the capture
        startCaptureSession()
    }
    
    func setupLayers() {
        if let detectionOverlay = detectionOverlay {
            detectionOverlay.removeFromSuperlayer()
        }

        detectionOverlay = CALayer() // container layer that has all the renderings of the observations
        detectionOverlay.name = "DetectionOverlay"
        detectionOverlay.bounds = CGRect(x: 0.0,
                                         y: 0.0,
                                         width: bufferSize.width,
                                         height: bufferSize.height)
        if let rootLayer = rootLayer {
            detectionOverlay.position = CGPoint(x: rootLayer.bounds.midX, y: rootLayer.bounds.midY)
            rootLayer.addSublayer(detectionOverlay)
        }
    }
    
    func updateLayerGeometry() {
        if let rootLayer = rootLayer {
            let bounds = rootLayer.bounds
            var scale: CGFloat
            
            let xScale: CGFloat = bounds.size.width / bufferSize.height
            let yScale: CGFloat = bounds.size.height / bufferSize.width
            
            scale = fmax(xScale, yScale)
            if scale.isInfinite {
                scale = 1.0
            }
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            
            // rotate the layer into screen orientation and scale and mirror
            detectionOverlay.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: scale, y: -scale))
            // center the layer
            detectionOverlay.position = CGPoint(x: bounds.midX, y: bounds.midY)
            
            CATransaction.commit()
        }
    }
    
    func createTextSubLayerInBounds(_ bounds: CGRect, identifier: String, confidence: VNConfidence, fructose: Float64) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.name = "Object Label"
        let formattedString = NSMutableAttributedString(string: String(format: "\(identifier)\nConfidence:  %.2f\nFructose:  %.2f ", confidence, fructose))
        let largeFont = UIFont(name: "Helvetica", size: 40.0)!
        formattedString.addAttributes([NSAttributedString.Key.font: largeFont], range: NSRange(location: 0, length: identifier.count))
        textLayer.string = formattedString
        textLayer.bounds = CGRect(x: 0, y: 0, width: bounds.size.height - 10, height: bounds.size.width - 10)
        textLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        textLayer.shadowOpacity = 0.7
        textLayer.shadowOffset = CGSize(width: 2, height: 2)
        textLayer.foregroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.0, 0.0, 0.0, 1.0])
        textLayer.contentsScale = 2.0 // retina rendering
        // rotate the layer into screen orientation and scale and mirror
        textLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: 1.0, y: -1.0))
        return textLayer
    }
    
    func createRoundedRectLayerWithBounds(_ bounds: CGRect) -> CALayer {
        let shapeLayer = CALayer()
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        shapeLayer.name = "Found Object"
        shapeLayer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 0.2, 0.4])
        shapeLayer.cornerRadius = 7
        return shapeLayer
    }
    
    @IBAction override func eatFruit(_ sender: UIButton){
        let alert = UIAlertController(title: "Fruit Detected", message: "Die folgende Frucht wurde erkannt: " + self.detectedFood!.0, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Hinzufügen", style: .default, handler: addToDB))
        alert.addAction(UIAlertAction(title: "Verwerfen", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Tagebucheintrag erstellen", style: .default, handler: nil))
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
