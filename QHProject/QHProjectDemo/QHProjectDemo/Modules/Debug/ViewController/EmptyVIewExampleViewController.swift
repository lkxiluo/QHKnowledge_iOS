//
//  EmptyVIewExampleVC.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/6/1.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

final class EmptyVIewExampleViewController: BaseViewController {
    private lazy var emptyViewSupView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        view.frame = CGRect(x: 0.0,
                            y: 0.0,
                            width: UIScreen.main.bounds.size.width,
                            height: UIScreen.main.bounds.size.height / 2.0)
        return view
    }()
    var isAutoViewEmpty = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(emptyViewSupView)
        title = "EmptyView 示例"
        addDebugView()
        emptyViewStatus = .noData
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {
                return
            }
            self.emptyViewStatus = .netError
        }
    }
    
    private func addDebugView() {
        let sureButton = UIButton(type: .custom)
        sureButton.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        sureButton.addTarget(self,
                             action: #selector(changeEnvironment),
                             for: .touchUpInside)
        sureButton.setTitle("切换", for: .normal)
        sureButton.setTitleColor(.black, for: .normal)
        
        let sureBarItem: UIBarButtonItem = UIBarButtonItem(customView: sureButton)
        navigationItem.rightBarButtonItem = sureBarItem
    }
    
    @objc private func changeEnvironment() {
        emptyViewStatus = .clear
        isAutoViewEmpty = !isAutoViewEmpty
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else {
                return
            }
            self.emptyViewStatus = .noData
        }
    }
    
    override func emptySuperView(type: EmptyViewType) -> UIView? {
        if isAutoViewEmpty {
            return self.emptyViewSupView
        } else {
            return view
        }
    }
    
    override func emptyButtonTitle(type: EmptyViewType) -> String? {
        if isAutoViewEmpty {
            return nil
        } else {
            return "重新设置"
        }
    }
}

extension EmptyVIewExampleViewController: SpiderRouterJumpProtocol {
    static func registerJumpRouter() -> RouterType {
        return (RouterJumpPath.debugEmptyView, NSStringFromClass(EmptyVIewExampleViewController.self))
    }
    
    static func isCanJumpRouter(path: String) -> Bool {
        return path == RouterJumpPath.debugEmptyView
    }
    
    static func createJumpRouterTarget(routerModel: SpiderRouterModel) -> UIViewController? {
        let emptyVC = EmptyVIewExampleViewController()
        return emptyVC
    }
}
