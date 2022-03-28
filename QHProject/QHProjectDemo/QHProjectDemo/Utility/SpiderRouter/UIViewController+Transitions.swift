//
//  UIViewController+Transitions.swift
//  VC 转场
//
//  Created by 罗坤 on 2021/7/10.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

extension UIViewController {
    // MARK: - 找到当前显示的 viewcontroller
    class func inViewController(base: UIViewController? = UIApplication.shared.inWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return inViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            return inViewController(base: tab.selectedViewController)
        }
        
        if let presented = base?.presentedViewController {
            return inViewController(base: presented)
        }
        
        if let split = base as? UISplitViewController {
            return inViewController(base: split.presentingViewController)
        }
        return base
    }
    
    /// 回调根 VC 指定的类对象
    /// - Parameters:
    ///   - rootVCClass: 指定类
    ///   - animation: 是否动画
    @discardableResult
    class func popToRootViewController(rootVCClass: AnyClass,
                                       animated: Bool = false) -> SpiderRouterJumpProtocol? {
        guard (UIViewController.inViewController() != nil) else {
            return nil
        }
        
        let rootViewController = UIApplication.shared.inWindow?.rootViewController
        
        if let tabbarController = rootViewController as? UITabBarController {
            guard let tabSelectedVC = tabbarController.selectedViewController else {
                return nil
            }
            dissWithVC(viewController: tabSelectedVC, animated: animated)
            
            guard let tabVCs = tabbarController.viewControllers else {
                return nil
            }
            
            for viewController in tabVCs {
                if let tabRootVC = viewController as? UINavigationController {
                    guard let visibleVC = tabRootVC.viewControllers.first else {
                        return nil
                    }
                    if let childTabbarVC = visibleVC as? SpiderRouterJumpProtocol,
                       visibleVC.isKind(of: rootVCClass) {
                        tabbarController.selectedViewController = viewController
                        return childTabbarVC
                    }
                } else {
                    if let childTabbarVC = viewController as? SpiderRouterJumpProtocol,
                       viewController.isKind(of: rootVCClass) {
                        tabbarController.selectedViewController = viewController
                        return childTabbarVC
                    }
                }
            }
        } else {
            dissWithVC(viewController: rootViewController, animated: animated)
            if let navigationVC = rootViewController as? UINavigationController {
                navigationVC.popToRootViewController(animated: animated)
                guard let vc = navigationVC.viewControllers.first as? SpiderRouterJumpProtocol,
                      ((navigationVC.viewControllers.first?.isKind(of: rootVCClass)) != nil) else {
                    return nil
                }
                return vc
            }
            
            guard let vc = rootViewController as? SpiderRouterJumpProtocol,
                  ((rootViewController?.isKind(of: rootVCClass)) != nil) else {
                return nil
            }
            return vc
        }
        
        return nil
    }
    
    private class func dissWithVC(viewController: UIViewController?, animated: Bool) {
        let presendedVC = viewController?.presentedViewController
        if presendedVC != nil {
            presendedVC?.dismiss(animated: animated, completion: nil)
        }
        
        let nextPresentVC = viewController?.presentedViewController?.presentedViewController
        if nextPresentVC != nil {
            nextPresentVC?.dismiss(animated: animated, completion: nil)
        }
        
        if presendedVC != nil {
            presendedVC?.dismiss(animated: animated, completion: nil)
        }
        
        if let selectedVC = viewController as? UINavigationController {
            selectedVC.popToRootViewController(animated: animated)
        }
    }
}
