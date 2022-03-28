//
//  SubViewPringAnimation.swift
//  转场子视图阻尼动画
//
//  Created by 罗坤 on 2021/7/28.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

class SubViewPringAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    var animationType: TransitionAnimatedType = .present
    convenience init(type: TransitionAnimatedType) {
        self.init()
        self.animationType = type
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionAnimatedDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch animationType {
        case .present:
            guard let toVC = transitionContext.viewController(forKey: .to), let toView = toVC.view else {
                return
            }

            let containerView = transitionContext.containerView
            containerView.addSubview(toView)
            guard toView.subviews.count == 1, let subView = toView.subviews.first else {
                return
            }
            
            subView.transform = CGAffineTransform(a: 0.7, b: 0, c: 0, d: 0.7, tx: 0, ty: 0);
            UIView.animate(withDuration: transitionAnimatedDuration * 3,
                           delay: 0,
                           usingSpringWithDamping: 1.0,
                           initialSpringVelocity: 20.0,
                           options: .curveEaseInOut) {
                toView.alpha = 1.0
                subView.transform = CGAffineTransform(a: 1.0,
                                                      b: 0,
                                                      c: 0,
                                                      d: 1.0,
                                                      tx: 0,
                                                      ty: 0);
            } completion: { finished in
                subView.transform = CGAffineTransform.identity
                transitionContext.completeTransition(true)
            }
        case .dismiss:
            guard let toVC = transitionContext.viewController(forKey: .from), let toView = toVC.view else {
                return
            }
            
            UIView.animate(withDuration: transitionAnimatedDuration, animations: {
                toView.alpha = 0.0
            }) { (_) in
                transitionContext.completeTransition(true)
            }
        }
    }
}
