//
//  PresentAnimation.swift
//  VC 模态模态弹窗，背景半透明，子视图往上弹, VC.view 只有一个子视图
//
//  Created by 罗坤 on 2021/7/24.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation


/// VC 模态模态弹窗，背景半透明，子视图往上弹
class SubViewPresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    var animationType: TransitionAnimatedType = .present
    init(animationType: TransitionAnimatedType) {
        self.animationType = animationType
    }
    
    /// 动画时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionAnimatedDuration
    }
    
    /// 动画效果
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
            
            subView.transform = CGAffineTransform(translationX: 0, y: (subView.frame.height))

            UIView.animate(withDuration: transitionAnimatedDuration, animations: {
                /// 背景变色
                toView.alpha = 1.0
                subView.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
            }) { ( _ ) in
                UIView.animate(withDuration: 0.2, animations: {
                    /// transform初始化
                    subView.transform = CGAffineTransform.identity
                }, completion: { (_) in
                    transitionContext.completeTransition(true)
                })
            }
        case .dismiss:
            guard let toVC = transitionContext.viewController(forKey: .from), let toView = toVC.view else {
                return
            }
            guard toVC.view.subviews.count == 1, let subView = toVC.view.subviews.first else {
                return
            }
            
            UIView.animate(withDuration: transitionAnimatedDuration, animations: {
                toView.alpha = 0.0
                subView.transform =  CGAffineTransform(translationX: 0, y: (subView.frame.height))
            }) { (_) in
                transitionContext.completeTransition(true)
            }
        }
    }
}
