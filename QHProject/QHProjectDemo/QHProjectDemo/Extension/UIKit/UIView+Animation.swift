//
//  UIView+Animation.swift
//  UIView 属性动画
//
//  Created by 罗坤 on 2021/7/1.
//  Copyright © 2021 Qdama. All rights reserved.
//

import Foundation

extension UIView {
    /// 旋转动画
    func rotationAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.duration = 0.8
        animation.autoreverses = false
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.repeatCount = MAXFLOAT
        layer.add(animation, forKey: nil)
    }
}
