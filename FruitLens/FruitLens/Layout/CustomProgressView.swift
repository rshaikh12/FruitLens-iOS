//
//  CustomProgressView.swift
//  FruitLens
//
//  Created by Emre Can Bolat on 07.06.20.
//  Copyright © 2020 ChristophWeber. All rights reserved.
//

import UIKit

class CustomProgressView: UIProgressView {
    
    var defaultProgressTint: UIColor?
    var defaultTrackingTint: UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        defaultProgressTint = progressTintColor
        defaultTrackingTint = trackTintColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        subviews.forEach { subview in
            subview.layer.masksToBounds = true
            subview.layer.cornerRadius = 10
        }
    }
    
    private struct Holder {
        static var _progressFull:Bool = false
        static var _completeLoading:Bool = false;
    }
    
    var progressFull:Bool {
        get {
            return Holder._progressFull
        }
        set(newValue) {
            Holder._progressFull = newValue
        }
    }
    
    var completeLoading:Bool {
        get {
            return Holder._completeLoading
        }
        set(newValue) {
            Holder._completeLoading = newValue
        }
    }
    
    func animateProgress(){
        if(completeLoading){
            return
        }
        
        UIView.animate(withDuration: 1, animations: {
            self.setProgress(self.progressFull ? 1.0 : 0.0, animated: true)
        })

        
        progressFull = !progressFull;
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.animateProgress();
        }
    }
    
    func startIndefinateProgress(){
        isHidden = false
        completeLoading = false
        animateProgress()
    }
    
    func stopIndefinateProgress(){
        completeLoading = true
        isHidden = true
    }
    
}
