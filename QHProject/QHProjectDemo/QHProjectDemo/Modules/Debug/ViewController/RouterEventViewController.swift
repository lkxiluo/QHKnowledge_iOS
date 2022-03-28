//
//  RouterEventVC.swift
//  事件回调路由使用示例
//
//  Created by 罗坤 on 2021/7/28.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

/// 事件回调路由使用示例
final class RouterEventViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "事件回调路由示例"
        
        let event1Button = UIButton(type: .custom)
        event1Button.setTitleColor(.blue, for: .normal)
        event1Button.addTarget(self, action: #selector(event1Action), for: .touchUpInside)
        event1Button.frame = CGRect(x: 40.0, y: 100.0, width: 84.0, height: 44.0)
        event1Button.setTitle("事件 1", for: .normal)
        view.addSubview(event1Button)
        
        let event2Button = UIButton(type: .custom)
        event2Button.setTitleColor(.blue, for: .normal)
        event2Button.addTarget(self, action: #selector(event2Action), for: .touchUpInside)
        event2Button.frame = CGRect(x: 40.0, y: 160.0, width: 84.0, height: 44.0)
        event2Button.setTitle("事件 2", for: .normal)
        view.addSubview(event2Button)
    }
    
    @objc func event1Action() {
        let query = [
            "message": "我是事件 1 的回调，你收到了吗？"
        ]
        Router.performEvent(routerPath: RouterEventPath.debugEvent1, query: query)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func event2Action() {
        let query = [
            "message": "我是事件 2 的回调，你收到了吗？"
        ]
        Router.performEvent(routerPath: RouterEventPath.debugEvent2, query: query)
        navigationController?.popViewController(animated: true)
    }
}

extension RouterEventViewController: SpiderRouterJumpProtocol {
    static func registerJumpRouter() -> RouterType {
        return (RouterJumpPath.debugEventRouter, NSStringFromClass(RouterEventViewController.self))
    }
    
    static func isCanJumpRouter(path: String) -> Bool {
        return path == RouterJumpPath.debugEventRouter
    }
    
    static func createJumpRouterTarget(routerModel: SpiderRouterModel) -> UIViewController? {
        let routerEventVC = RouterEventViewController()
        return routerEventVC
    }
}
