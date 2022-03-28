//
//  HudExampleVC.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/6/1.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation
import Lottie

final class HudExampleViewController: BaseViewController {
    
    var isCustomer = false
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hud 示例"
        addDebugView()
        reload()
    }
    
    private func addDebugView() {
        let sureButton = UIButton(type: .custom)
        
        sureButton.setTitle("切换", for: .normal)
        sureButton.setTitleColor(.black, for: .normal)
        sureButton.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        sureButton.addTarget(self, action: #selector(changeEnvironment), for: .touchUpInside)
        
        let sureBarItem: UIBarButtonItem = UIBarButtonItem(customView: sureButton)
        navigationItem.rightBarButtonItem = sureBarItem
    }
    
    @objc private func changeEnvironment() {
        isCustomer = !isCustomer
        reload()
    }
    
    private func reload() {
        if isCustomer {
            ProgressHUDManager.showInTarget(target: self,
                                            superView: view,
                                            type: .customer,
                                            animation: true)
        } else {
            ProgressHUDManager.showInTarget(target: self, superView: view, animation: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else {
                return
            }
            ProgressHUDManager.hidenHud(superView: self.view, animation: true)
        }
    }
}

extension HudExampleViewController: HUDCustomProtocol {
    func hudCustomView() -> UIView? {
        if isCustomer {
            let path : String = Bundle.main.path(forResource: "hud_loading_uploading", ofType: "json")!
            let lottieAnimationView = AnimationView.init(filePath: path)
            lottieAnimationView.play()
            return lottieAnimationView
        }
        return nil
    }
}

extension HudExampleViewController: SpiderRouterJumpProtocol {
    static func registerJumpRouter() -> RouterType {
        return (RouterJumpPath.debugHud, NSStringFromClass(HudExampleViewController.self))
    }
    
    static func isCanJumpRouter(path: String) -> Bool {
        return path == RouterJumpPath.debugHud
    }
    
    static func createJumpRouterTarget(routerModel: SpiderRouterModel) -> UIViewController? {
        let hudVC = HudExampleViewController()
        return hudVC
    }
}
