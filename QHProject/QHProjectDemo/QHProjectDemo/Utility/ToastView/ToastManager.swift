//
//  ToastManager.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/5/28.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation
import Toast_Swift

/// 内容提示管理类
struct ToastManager {
    enum ToastType {
        case normal     // 正常提示，只有文字内容
        case error      // 错误提示，包含错误图片和提示内容
        case warning    // 警告提示，包含警告图标和提示内容
        
        func typeImage() -> UIImage? {
            switch self {
            case .normal:
                return UIImage(named: "")
            case .error:
                return UIImage(named: "common_toast_error")
            case .warning:
                return UIImage(named: "common_toast_warning")
            }
        }
    }
    private static var style = ToastStyle()
    static func showToastInView(inView: UIView? = UIViewController.current()?.view,
                                type: ToastType = .normal,
                                message: String) {
        guard let superView = inView, inView == UIViewController.current()?.view else {
            return
        }
        superView.hideAllToasts()
        
        let duration = min(3.0, 1.0 + 0.1 * Double(message.count))
        let image = type.typeImage()
        
        style.messageFont = FontDesign.r14
        style.cornerRadius = 8.0
        style.horizontalPadding = SizeDesign.margin
        style.verticalPadding = SizeDesign.margin
        style.imageSize = CGSize(width: 18.0, height: 18.0)
        
        superView.makeToast(message,
                            duration: duration,
                            position: .center,
                            title: nil,
                            image: image,
                            style: style)
    }
}
