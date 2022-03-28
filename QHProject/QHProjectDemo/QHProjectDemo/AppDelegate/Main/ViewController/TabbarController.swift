//
//  TabbarController.swift
//  QdamaECMall
//
//  Created by 罗坤 on 2021/5/5.
//  Copyright © 2021 Qdama. All rights reserved.
//

import Foundation
import UIKit

/// 底部导航栏
final class TabbarController: UITabBarController {
    
    /// 购物车按钮
    private var bagTabbarItem: UITabBarItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13, *) {
            UITabBar.appearance().tintColor = .black
            UITabBar.appearance().unselectedItemTintColor = .black
        }
        initTabs()
        #if DEBUG
//        initFpsWindow()
        #endif
    }
    
    // MARK: - Public
    func shopBagNumber(number: Int) {
        guard let barItem = bagTabbarItem else {
            return
        }
        
        if number >= 100 {
            barItem.badgeValue = "99+"
        } else if number <= 0 {
            barItem.badgeValue = nil
        } else {
            barItem.badgeValue = "\(number)"
        }
    }
    
    // MARK: - Private
    /// 底部导航栏初始化
    private func initTabs() {
        selectedIndex = 0
        tabBar.backgroundImage = UIImage().drawImage(from: .white)
        tabBar.shadowImage = UIImage().drawImage(from: .clear)
        tabBar.layer.shadowColor = UIColor(red: 0.52, green: 0.53, blue: 0.53, alpha: 0.1).cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowOpacity = 1.0
        tabBar.layer.shadowRadius = 7.5
        tabBar.layer.shadowPath = UIBezierPath(rect: tabBar.bounds).cgPath

        setupTabarController()
    }
    
    private func setupTabarController() {
        let homeSelectedImage = UIImage(named: "tabbar_home_selected") ?? UIImage()
        let homeNormalImage =  UIImage(named: "tabbar_home_normal") ?? UIImage()
        let homeViewController = HomeViewController()
        let homeNavigationController = childViewController(homeViewController,
                                                           localizedString("Gree_Tabbar_Home"),
                                                           homeNormalImage,
                                                           homeSelectedImage)
        
        let cateSelectedImage = UIImage(named: "tabbar_category_selected") ?? UIImage()
        let cateNormalImage =  UIImage(named: "tabbar_category_normal") ?? UIImage()
        let categoryViewController = CategoryViewController()
        let categoryNavigationController = childViewController(categoryViewController,
                                                               localizedString("Gree_Tabbar_Category"),
                                                               cateNormalImage,
                                                               cateSelectedImage)
        
        let commnutitySelectedImage = UIImage(named: "tabbar_community_selected") ?? UIImage()
        let commnutityNormalImage =  UIImage(named: "tabbar_community_normal") ?? UIImage()
        let communityController = CommunityViewController()
        let communityNavigationController = childViewController(communityController,
                                                                localizedString ("Gree_Tabbar_Community"),
                                                                commnutityNormalImage,
                                                                commnutitySelectedImage)
        
        let shopSelectedImage = UIImage(named: "tabbar_shopcart_selected") ?? UIImage()
        let shopNormalImage =  UIImage(named: "tabbar_shopcart_normal") ?? UIImage()
        let shopBagViewController = ShopBagViewController()
        let shopBagNavigationController =  childViewController(shopBagViewController,
                                                               localizedString("Gree_Tabbar_ShopCart"),
                                                               shopNormalImage,
                                                               shopSelectedImage)
        
        let mineSelectedImage = UIImage(named: "tabbar_mine_selected") ?? UIImage()
        let mineNormalImage =  UIImage(named: "tabbar_mine_normal") ?? UIImage()
        let mineViewController = MineViewController()
        let mineNavigationContrller = childViewController(mineViewController,
                                                          localizedString("Gree_Tabbar_Mine"),
                                                          mineNormalImage,
                                                          mineSelectedImage)
        
        let tabbarChildControllers = [ homeNavigationController,
                                       categoryNavigationController,
                                       communityNavigationController,
                                       shopBagNavigationController,
                                       mineNavigationContrller ]
        setViewControllers(tabbarChildControllers, animated: false)
    }
    
    private func childViewController(_ viewController: UIViewController,
                                     _ title: String,
                                     _ normalImage: UIImage,
                                     _ selectedImage: UIImage) -> BaseNavigationController {
        let tabBarItem = UITabBarItem(title: title,
                                      image: normalImage.withRenderingMode(.alwaysOriginal),
                                      selectedImage: selectedImage.withRenderingMode(.alwaysOriginal))
        tabBarItem.configItemStyle()
        tabBarItem.badgeColor = .main
        if viewController.isKind(of: ShopBagViewController.self) {
            bagTabbarItem = tabBarItem
        }
        
        let navigationBar = BaseNavigationController(rootViewController: viewController)
        navigationBar.tabBarItem = tabBarItem
        viewController.navigationItem.title = title
        return navigationBar
    }
}

// MARK: - UITabBarItem 样式配置
extension UITabBarItem {
    func configItemStyle() {
        let selectedTitleAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: FontDesign.m10,
            NSAttributedString.Key.foregroundColor: UIColor.tabbarItem
        ]
        let normalTitleAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: FontDesign.m10,
            NSAttributedString.Key.foregroundColor: UIColor.c1A1A1A
        ]
        setTitleTextAttributes(selectedTitleAttributes, for: UIControl.State.selected)
        setTitleTextAttributes(selectedTitleAttributes, for: UIControl.State.highlighted)
        setTitleTextAttributes(normalTitleAttributes, for: UIControl.State.normal)
    }
}
