//
//  DismissMenuAnimator.swift
//  FruitLens
//
//  Created by Emre Can Bolat on 07.06.20.
//  Copyright © 2020 Emre Can Bolat. All rights reserved.
//

import UIKit

class DismissMenuAnimator : NSObject {
}

extension DismissMenuAnimator : UIViewControllerAnimatedTransitioning {
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
        let snapshot = containerView.viewWithTag(PopupHelper.snapshotNumber)

        if PopupHelper.blur {
            snapshot?.removeBlurEffect(withDuration: transitionDuration(using: transitionContext))
        }
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                //snapshot?.frame = CGRect(origin: CGPoint.zero, size: UIScreen.main.bounds.size)
                //toVC.view.frame = CGRect(origin: CGPoint(x: 0, y: UIScreen.main.bounds.height), size: UIScreen.main.bounds.size)
                if PopupHelper.shadow {
                    snapshot?.alpha = 1.0
                }
                fromVC.view.center.y += UIScreen.main.bounds.height
        },
            completion: { _ in
                let didTransitionComplete = !transitionContext.transitionWasCancelled
                if didTransitionComplete {
                    containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
                    
                    if PopupHelper.blur {
                        snapshot?.removeFromSuperview()
                        snapshot?.removeBlurFromSuperView()
                    }
                }
                transitionContext.completeTransition(didTransitionComplete)
        }
        )
    }
}
