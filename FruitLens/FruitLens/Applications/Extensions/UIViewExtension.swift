//
//  UIViewExtension.swift
//  FruitLens
//
//  Created by Emre Can Bolat on 07.06.20.
//  Copyright © 2020 ChristophWeber. All rights reserved.
//

import UIKit

extension UIView {
    
    func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
    
    public func snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImage
    }
    
    public func snapshotView() -> UIView? {
        if let snapshotImage = snapshotImage() {
            return UIImageView(image: snapshotImage)
        } else {
            return nil
        }
    }
    
    func addBlurEffect(withDuration: TimeInterval) {
        let blurEffect = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = frame
        addSubview(effectView)
        effectView.alpha = 0
        
        UIView.animate(withDuration: withDuration) {
            effectView.alpha = 1.0
        }
    }
    
    func removeBlurEffect(withDuration: TimeInterval) {
        for subview in subviews {
            if let blur = subview as? UIVisualEffectView {
                UIView.animate(withDuration: withDuration, animations: { blur.alpha = 0 })
            }
        }
    }
    
    func removeBlurFromSuperView() {
        for subview in subviews {
            if let blur = subview as? UIVisualEffectView {
                blur.removeFromSuperview()
            }
        }
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        
        mask.frame = self.bounds
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func loadFromNibIfEmbeddedInDifferentNib() -> Self {
        let isJustAPlaceholder = subviews.count == 0
        if isJustAPlaceholder {
            let theRealThing = type(of: self).viewFromNib()
            theRealThing.frame = frame
            translatesAutoresizingMaskIntoConstraints = false
            theRealThing.translatesAutoresizingMaskIntoConstraints = false
            return theRealThing
        }
        return self
    }
    
    class func viewFromNib(withOwner owner: Any? = nil) -> Self {
        let name = String(describing: type(of:      self)).components(separatedBy: ".")[0]
        let view = UINib(nibName: name, bundle: nil).instantiate(withOwner: owner, options: nil)[0]
        return cast(view)!
    }
}

private func cast<T, U>(_ value: T) -> U? {
    return value as? U
}
