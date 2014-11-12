//
//  TransitionManager.swift
//  DreamRight
//
//  Created by Kevin Sullivan on 11/7/14.
//  Copyright (c) 2014 SideApps. All rights reserved.
//

import UIKit

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
    
    private var presenting = true
    
    // MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    // animate a change from one viewcontroller to another
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView()
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        toView.alpha = 0.0
        
        let tempView = UIView(frame: CGRect(origin: fromView.frame.origin, size: fromView.frame.size))
        tempView.backgroundColor = DreamRightSK.color
        
        container.addSubview(tempView)
        container.sendSubviewToBack(tempView)
        container.addSubview(toView)
        container.sendSubviewToBack(toView)
        
        let duration = self.transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration / 2, animations: {
            fromView.alpha = 0.0
            }, completion: { finished in
                container.sendSubviewToBack(tempView)
                UIView.animateWithDuration(duration / 2, animations: {
                    toView.alpha = 1.0
                    }, completion: { finished in
                        fromView.removeFromSuperview()
                        tempView.removeFromSuperview()
                        fromView.alpha = 1.0
                        transitionContext.completeTransition(true)
                })
        })
    }
    
    // return how many seconds the transiton animation will take
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 1.2
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    // return the animataor when presenting a viewcontroller
    // remmeber that an animator (or animation controller) is any object that aheres to the UIViewControllerAnimatedTransitioning protocol
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        // these methods are the perfect place to set our `presenting` flag to either true or false - voila!
        self.presenting = true
        return self
    }
    
    // return the animator used when dismissing from a viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
}