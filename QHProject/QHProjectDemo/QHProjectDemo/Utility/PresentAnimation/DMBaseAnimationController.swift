//
//  DMPresentAnimateController.swift
//  QHProjectECMall
//
//  Created by zx on 2021/7/6.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

extension DMPresentAnimateController {
    enum DMPresentStyle {
        case presenting
        case dismissing
    }
}

///
class DMPresentAnimateController: NSObject, UIViewControllerAnimatedTransitioning {

    var animationType: DMPresentStyle = .presenting
    
    convenience init(type: DMPresentStyle) {
        self.init()
        self.animationType = type
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        switch self.animationType {
        case .presenting:
            return 0.5
        case .dismissing:
            return 1
        }
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        if self.animationType == .presenting {
            if let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) {
                containerView.addSubview(toVC.view)
                
                toVC.view.alpha = 0
                UIView.animate(withDuration: 0.3,
                               delay: 0.1,
                               usingSpringWithDamping: 1.0,
                               initialSpringVelocity: 1,
                               options: [.beginFromCurrentState, .allowUserInteraction]) {
                    toVC.view.alpha = 1
                } completion: { (finished) in
                    
                    transitionContext.completeTransition(true)
                }
            }
        } else if (self.animationType == .dismissing) {
            if let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) {
                
                UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.beginFromCurrentState, .allowUserInteraction]) {
                    fromVC.view.alpha = 0
                } completion: { (finish) in
                    transitionContext.completeTransition(true)
                }
            }
        }
    }
}
