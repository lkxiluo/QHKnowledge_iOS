//
//  ProgressHUDManager.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/5/6.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

/// 自定义加载视图
protocol HUDCustomProtocol {
    /// 自定加载视图
    func hudCustomView() -> UIView?
}

/// 加载框管理
final class ProgressHUDManager {
    /// 加载框类型
    enum HUDType {
        /// 自定红色加载动画
        case redLoading
        /// 自定定义弹窗加载框
        case toastLoading
        /// 自定义成功弹窗
        case toastSuccessed
        /// 自定义失败弹窗
        case toastFailed
        /// 全自定义
        case customer
    }
    
    private static let shared = ProgressHUDManager()
    // MARK: - ClassMethod
    class func showInTarget(target: HUDCustomProtocol? = nil,
                            superView: UIView,
                            type: HUDType = .redLoading,
                            message: String = "",
                            animation: Bool) {
        ProgressHUDManager.shared.show(target: target,
                                       superView: superView,
                                       type: type,
                                       message: message,
                                       animation: animation)
    }
    
    class func hidenHud(superView: UIView, animation: Bool) {
        for subView in superView.subviews {
            if subView.isKind(of: MBProgressHUD.self) {
                let hudView = subView as! MBProgressHUD
                hudView.hide(animated: animation)
                hudView.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Private
    private func hiden(superView: UIView, animation: Bool) {
        for subView in superView.subviews {
            if subView.isKind(of: MBProgressHUD.self) {
                let hudView = subView as! MBProgressHUD
                hudView.hide(animated: animation)
                hudView.removeFromSuperview()
            }
        }
    }
    
    private func show(target: HUDCustomProtocol? = nil,
                      superView: UIView,
                      type: HUDType,
                      message: String,
                      animation: Bool) {
        ProgressHUDManager.hidenHud(superView: superView, animation: animation)
        
        let hudView = MBProgressHUD()
        hudView.removeFromSuperViewOnHide = true
        hudView.areDefaultMotionEffectsEnabled = false
        hudView.backgroundView.color = .clear
        hudView.bezelView.style = .solidColor
        hudView.bezelView.layer.cornerRadius = 8.0
        hudView.bezelView.color = UIColor.black.withAlphaComponent(0.7)
        hudView.label.text = message
        hudView.label.font = FontDesign.r14
        hudView.mode = .customView
        hudView.isSquare = true
        hudView.minSize = CGSize(width: 96.0, height: 96.0)
        
        switch type {
        case .redLoading:
            hudView.bezelView.color = .clear
            hudView.bezelView.backgroundColor = .clear
            hudView.label.textColor = .c999999
            hudView.customView = redLoadingView()
        case .toastLoading:
            hudView.customView = toastLoadingView()
            hudView.label.textColor = .white
        case .toastSuccessed:
            hudView.customView = toastSuccessedView()
            hudView.label.textColor = .white
        case .toastFailed:
            hudView.customView = toastFailedView()
            hudView.label.textColor = .white
        case .customer:
            hudView.bezelView.color = .clear
            hudView.bezelView.backgroundColor = .clear
            if let hudTarget = target, let customView = hudTarget.hudCustomView() {
                hudView.customView = customView
                hudView.label.text = ""
            }
        }
        superView.addSubview(hudView)
        hudView.show(animated: animation)
    }
    
    private func redLoadingView() -> UIView {
        let redLoadingImageView = UIImageView()
        redLoadingImageView.image = UIImage(named: "common_hud_loading")
        redLoadingImageView.rotationAnimation()
        return redLoadingImageView
    }
    
    private func toastLoadingView() -> UIView {
        let toastLoadingImageView = UIImageView()
        toastLoadingImageView.image = UIImage(named: "common_hud_loading")
        toastLoadingImageView.rotationAnimation()
        return toastLoadingImageView
    }
    
    private func toastSuccessedView() -> UIView {
        let successImageView = UIImageView()
        successImageView.image = UIImage(named: "common_hud_loading")
        return successImageView
    }
    
    private func toastFailedView() -> UIView {
        let failedImageView = UIImageView()
        failedImageView.image = UIImage(named: "common_hud_loading")
        return failedImageView
    }
}
