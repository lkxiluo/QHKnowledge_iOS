//
//  ToastExampleVV.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/6/1.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

final class ToastExampleViewController: BaseViewController {
    private enum ToastType: Int {
        case normal
        case warning
        case error
    }
    private let buttonTitles: [String] = ["默认提示", "警告提示", "错误提示"]
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ToastView 使用示例"
        createButtons()
    }
    
    private func createButtons() {
        let offsetX = 24.0
        var offsetY = 100.0
        
        let buttonHeight = 44.0
        let buttonWidth = 220.0
        
        for index in 0..<buttonTitles.count {
            let title = buttonTitles[index]
            let button = UIButton(type: .custom)
            
            button.frame = CGRect(x: offsetX, y: offsetY, width: buttonWidth, height: buttonHeight)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .white
            button.layer.cornerRadius = 4.0
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1.0
            button.tag = index
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            view.addSubview(button)
            
            offsetY = (offsetY + buttonHeight + 12.0)
        }
    }
    
    @objc private func buttonAction(button: UIButton) {
        let type = ToastType(rawValue: button.tag)
        switch type {
        case .normal:
            ToastManager.showToastInView(message: "我是一个默认的提示~")
        case .warning:
            ToastManager.showToastInView(type: .warning, message: "我是一个警告的提示~")
        case .error:
            ToastManager.showToastInView(type: .error, message: "我是一个错误的提示~")
        case .none:
            DLog("未知提示类型")
        }
    }
}

extension ToastExampleViewController: SpiderRouterJumpProtocol {
    static func registerJumpRouter() -> RouterType {
        return (RouterJumpPath.debugToastView, NSStringFromClass(ToastExampleViewController.self))
    }
    
    static func isCanJumpRouter(path: String) -> Bool {
        return path == RouterJumpPath.debugToastView
    }
    
    static func createJumpRouterTarget(routerModel: SpiderRouterModel) -> UIViewController? {
        let toastVC = ToastExampleViewController()
        return toastVC
    }
}
