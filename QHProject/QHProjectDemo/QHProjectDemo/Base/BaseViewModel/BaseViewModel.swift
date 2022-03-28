//
//  BaseViewModel.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/7/23.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

/// 错误提醒方式
enum ErrorTipType {
    case alert
    case toast
}

class BaseViewModel {
    deinit {
        DLog("对象释放~~~ \(self)")
    }
    
    @discardableResult
    func requestErrorHandle(model: Codable?, type: ErrorTipType? = .toast) -> Bool {
        guard let model = model else {
            return false
        }
        
        if let responseModel = model as? ResponseModel {
            guard let currentVC = UIViewController.current() else {
                return false
            }
            
            switch type {
            case .alert:
//                let alertVC = DMAlertController(title: "提示",
//                                                message: responseModel.message,
//                                                style: .alert)
//                let knowAction = DMAlertAction(title: localizedString("QDM_Common_IKnow")) {
//                    currentVC.navigationController?.popViewController(animated: true)
//                }
//                alertVC.addActions(action: knowAction)
//                currentVC.present(alertVC, animated: true, completion: nil)
                break
            case .toast:
                guard let message = responseModel.message, !message.isEmpty else {
                    return false
                }
                ToastManager.showToastInView(message: message)
            case .none:
                break
            }
            return true
        }
        return false
    }
}
