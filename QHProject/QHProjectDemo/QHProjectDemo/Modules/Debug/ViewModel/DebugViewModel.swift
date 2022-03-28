//
//  DebugVM.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/6/1.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation


struct DebugViewModel {
    var debugModels: [DebugSectionModel] = []
    init() {
        initEnvironment()
//        initRecodeView()
        initComExample()
        initFlutter()
        initBusiness()
    }
    
    // MARK: - 开发渠道切换
    // MARK: - 开发环境切换
    /// 开发环境切换
    private mutating func initEnvironment() {
        var testModel = DebugRowModel()
        testModel.title = "测试环境"
        testModel.value = RequestDevEnrironment.test
        if RequestApiConfig.shared.getDevEnrironment() == RequestDevEnrironment.test {
            testModel.image = UIImage(named: "common_check_selected")
        }
        
        var qaModel = DebugRowModel()
        qaModel.title = "dev 环境"
        qaModel.value = RequestDevEnrironment.dev
        if RequestApiConfig.shared.getDevEnrironment() == RequestDevEnrironment.dev {
            qaModel.image = UIImage(named: "common_check_selected")
        }
        
        var distributeModel = DebugRowModel()
        distributeModel.title = "线上环境"
        distributeModel.value = RequestDevEnrironment.distribute
        if RequestApiConfig.shared.getDevEnrironment() == RequestDevEnrironment.distribute {
            distributeModel.image = UIImage(named: "common_check_selected")
        }
        
        var evrironmentModel = DebugSectionModel()
        evrironmentModel.sectionTitle = "开发环境"
        evrironmentModel.sectionRows.append(testModel)
        evrironmentModel.sectionRows.append(qaModel)
        evrironmentModel.sectionRows.append(distributeModel)
        
        debugModels.append(evrironmentModel)
    }
    
    // MARK: - 重复代码检测结果
    /// 重复代码检测结果
    private mutating func initRecodeView() {
        var reViewCodeModel = DebugSectionModel()
        reViewCodeModel.sectionTitle = "重复代码检测结果"
        debugModels.append(reViewCodeModel)
    }
    
    // MARK: - 组件使用案例
    /// 组件使用案例
    private mutating func initComExample() {
        var exampleModel = DebugSectionModel()
        exampleModel.sectionTitle = "组件使用示例"
        
        var alertViewModel = DebugRowModel()
        alertViewModel.title = "AlertView 使用示例"
        alertViewModel.value = RouterJumpPath.testApi
        exampleModel.sectionRows.append(alertViewModel)
        
        var toastViewModel = DebugRowModel()
        toastViewModel.title = "ToastView 使用示例"
        toastViewModel.value = RouterJumpPath.debugToastView
        exampleModel.sectionRows.append(toastViewModel)
        
        var emptyViewModel = DebugRowModel()
        emptyViewModel.title = "EmptyView 使用示例"
        emptyViewModel.value = RouterJumpPath.debugEmptyView
        exampleModel.sectionRows.append(emptyViewModel)
        
        var hudModel = DebugRowModel()
        hudModel.title = "Hud 使用示例"
        hudModel.value = RouterJumpPath.debugHud
        exampleModel.sectionRows.append(hudModel)
        
        var networkModel = DebugRowModel()
        networkModel.title = "networking 使用示例"
        networkModel.value = RouterJumpPath.debugNet
        exampleModel.sectionRows.append(networkModel)
        
        var routerModel = DebugRowModel()
        routerModel.title = "router 路由使用示例"
        routerModel.value = RouterJumpPath.debugRouter
        exampleModel.sectionRows.append(routerModel)
        
        var refreshModel = DebugRowModel()
        refreshModel.title = "上下拉刷新使用示例"
        refreshModel.value = RouterJumpPath.debugRefresh
        exampleModel.sectionRows.append(refreshModel)
        
        debugModels.append(exampleModel)
    }
    
    // MARK: - Flutter
    private mutating func initFlutter() {
        var flutterModel = DebugSectionModel()
        flutterModel.sectionTitle = "Flutter 混编框架"
        
        var flutterViewModel = DebugRowModel()
        flutterViewModel.title = "Flutter 使用示例"
        flutterViewModel.value = RouterJumpPath.debugToastView
        flutterModel.sectionRows.append(flutterViewModel)
        
        debugModels.append(flutterModel)
    }
    
    // MARK: - 业务功能测试
    /// 业务功能测试
    private mutating func initBusiness() {
        var businessModel = DebugSectionModel()
        businessModel.sectionTitle = "业务调试"
        
        debugModels.append(businessModel)
    }
}
