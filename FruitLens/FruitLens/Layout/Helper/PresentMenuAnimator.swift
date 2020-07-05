//
//  PresentMenuAnimator.swift
//  FruitLens
//
//  Created by Emre Can Bolat on 07.06.20.
//  Copyright © 2020 ChristophWeber. All rights reserved.
//

import UIKit

class PresentMenuAnimator : NSObject {
}

extension PresentMenuAnimator : UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else {
                return
        }
        let containerView = transitionContext.containerView
        containerView.insertSubview(fromVC.view, belowSubview: toVC.view)
        
        
        // replace main view with snapshot
        if let snapshot = fromVC.view.snapshotView() {
            snapshot.tag = PopupHelper.snapshotNumber
            snapshot.isUserInteractionEnabled = false
            //snapshot.alpha = 0.2
            
//            let blackView = UIView(frame: snapshot.frame)
//            blackView.backgroundColor = .black
//            blackView.alpha = 0.85;
//            snapshot.addSubview(blackView)
            
            containerView.insertSubview(snapshot, aboveSubview: fromVC.view)
            containerView.insertSubview(toVC.view, aboveSubview: snapshot)
            
            toVC.view.center.y = UIScreen.main.bounds.height
            fromVC.view.isHidden = true
            //toVC.view.layer.shadowOpacity = 0.7
            if PopupHelper.blur {
                snapshot.addBlurEffect(withDuration: transitionDuration(using: transitionContext))
            }
            
            UIView.animate(
                withDuration: transitionDuration(using: transitionContext),
                animations: {
                    //snapshot.center.x += UIScreen.main.bounds.width * PopupHelper.menuWidth
                    //snapshot.center.y -= UIScreen.main.bounds.height * PopupHelper.menuHeight
                    if PopupHelper.shadow {
                        snapshot.alpha = 0.15
                    }
                    
                    toVC.view.center.y -= UIScreen.main.bounds.height/2
            },
                completion: { _ in
                    fromVC.view.isHidden = false
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            )
        }
    }
}
