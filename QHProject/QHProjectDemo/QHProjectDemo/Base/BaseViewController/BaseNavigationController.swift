//
//  BaseNavigationController.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/5/5.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation
import UIKit

/// 自定义顶部导航栏
final class BaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    ///
    private func setupViews() {
        
        let titleAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: FontDesign.m17,
            NSAttributedString.Key.foregroundColor: UIColor.c1A1A1A
        ]
        navigationBar.titleTextAttributes = titleAttributes
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance.init(idiom: .phone)
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .white
            navigationBar.standardAppearance = appearance
            navigationBar.compactAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationBar.shadowImage = UIImage()
            navigationBar.setBackgroundImage(UIImage(), for: .default)
        }
        navigationBar.isTranslucent = false
        navigationBar.tintColor = .c1A1A1A
    }
}

extension BaseNavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count >= 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: true)
    }
}
