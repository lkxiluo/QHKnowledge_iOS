//
//  AppLaunchManager.swift
//  管理 APP 冷启动过程
//  将冷却启动分为三个阶段:
//  T1: main 函数之前，这部分基本不用处理
//  T2: main ~ didFinishLaunching，必要处理的，
//      包含神策、bugly、rootViewController(引导(广告)页/tabbarController) 设置
//  T3: didFinishLaunching ~ 首页展示，首页>隐私协议>强更>定位>通知>广告>活动>其他
//
//  Created by 罗坤 on 2021/5/12.
//  Copyright © 2021 Qdama. All rights reserved.
//

import Foundation

struct AppLaunchManager {
    /// 启动 App
    func appLaunch() {
        launchT2()
        launchT3()
    }
    
    private func launchT2() {
        guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
//        launchT2Manager.performModels.append(appDelegate)
//        launchT2Manager.performQueue()
    }
    
    private func launchT3() {
        
    }
}
