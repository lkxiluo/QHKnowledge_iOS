//
//  BaseSubViewPresentVC.swift
//  背景透明，从下往上的弹窗
//
//  Created by 罗坤 on 2021/8/11.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

class BaseSubViewPresentViewController: UIViewController {
    deinit {
        DLog("对象释放~~~ \(self)")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.7)
    }
    
    /// 显示视图
    func show(animated: Bool = true, completion: (() -> Void)?) {
        UIViewController.current()?.present(self, animated: animated, completion: completion)
    }
    
    /// 隐藏视图
    func disMiss(animated: Bool = true, completion: (() -> Void)?) {
        dismiss(animated: animated, completion: completion)
    }
}

// MARK: - 转场动画delegate
extension BaseSubViewPresentViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animated = SubViewPresentAnimation(animationType: .present)
        return animated
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animated = SubViewPresentAnimation(animationType: .dismiss)
        return animated
    }
}

