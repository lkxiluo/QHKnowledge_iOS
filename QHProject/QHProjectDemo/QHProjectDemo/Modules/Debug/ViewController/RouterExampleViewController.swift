//
//  RouterExampleVC.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/7/6.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

final class RouterExampleViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "router 使用示例"
        let pushButton = UIButton(type: .custom)
        pushButton.setTitleColor(.blue, for: .normal)
        pushButton.addTarget(self, action: #selector(pushAction), for: .touchUpInside)
        pushButton.frame = CGRect(x: 40.0, y: 100.0, width: 84.0, height: 44.0)
        pushButton.setTitle("push", for: .normal)
        view.addSubview(pushButton)
        
        let presentButton = UIButton(type: .custom)
        presentButton.setTitleColor(.blue, for: .normal)
        presentButton.addTarget(self, action: #selector(presentAction), for: .touchUpInside)
        presentButton.frame = CGRect(x: 40.0, y: 160.0, width: 84.0, height: 44.0)
        presentButton.setTitle("present", for: .normal)
        view.addSubview(presentButton)
        
        let event1Button = UIButton(type: .custom)
        event1Button.setTitleColor(.blue, for: .normal)
        event1Button.addTarget(self, action: #selector(event1Action), for: .touchUpInside)
        event1Button.frame = CGRect(x: 160.0, y: 100.0, width: 120.0, height: 44.0)
        event1Button.setTitle("事件回调 1", for: .normal)
        view.addSubview(event1Button)
        
        let event2Button = UIButton(type: .custom)
        event2Button.setTitleColor(.blue, for: .normal)
        event2Button.addTarget(self, action: #selector(event2Action), for: .touchUpInside)
        event2Button.frame = CGRect(x: 160.0, y: 160.0, width: 120.0, height: 44.0)
        event2Button.setTitle("事件回调 2", for: .normal)
        view.addSubview(event2Button)
    }
    
    @objc func pushAction() {
        Router.performJump(routerPath: RouterJumpPath.debugPushRouter,
                             query: ["title": "这是一个 push 过来的 VC"])
    }
    
    @objc func presentAction() {
        Router.performJump(routerPath: RouterJumpPath.debugPresentRouter,
                             animationType: .present,
                             query: ["title": "这是一个 present 过来的 VC"])
    }
    
    @objc func event1Action() {
        Router.registerEventRouter(routerPath: RouterEventPath.debugEvent1, target: self)
        Router.performJump(routerPath: RouterJumpPath.debugEventRouter, query: nil)
    }
    
    @objc func event2Action() {
        Router.registerEventRouter(routerPath: RouterEventPath.debugEvent2, target: self)
        Router.performJump(routerPath: RouterJumpPath.debugEventRouter, query: nil)
    }
}

extension RouterExampleViewController: SpiderRouterJumpProtocol {
    static func registerJumpRouter() -> RouterType {
        return (RouterJumpPath.debugRouter, NSStringFromClass(RouterExampleViewController.self))
    }
    
    static func isCanJumpRouter(path: String) -> Bool {
        return path == RouterJumpPath.debugRouter
    }
    
    static func createJumpRouterTarget(routerModel: SpiderRouterModel) -> UIViewController? {
        let routerVC = RouterExampleViewController()
        return routerVC
    }
}

extension RouterExampleViewController: SpiderRouterEventProtocol {
    func isCanEventHandle(path: String) -> Bool {
        #warning("根据实际情况设置")
        return path == RouterEventPath.debugEvent1 || path == RouterEventPath.debugEvent2
    }
    
    func eventHandleWithRouterModel(routerModel: SpiderRouterModel) {
        #warning("根据实际情况设置、移除，调用 asyncAfter 是为了看效果和实际使用无关")
        if routerModel.path == RouterEventPath.debugEvent1 {
            DLog(routerModel.query)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                ToastManager.showToastInView(message: routerModel.query?["message"] as? String ?? "")
                Router.removeEventRouter(routerPath: RouterEventPath.debugEvent1,
                                           target: self)
            }
        } else if (routerModel.path == RouterEventPath.debugEvent2) {
            DLog(routerModel.query)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                ToastManager.showToastInView(message: routerModel.query?["message"] as? String ?? "")
                Router.removeEventRouter(routerPath: RouterEventPath.debugEvent2,
                                           target: self)
            }
        }
    }
}
