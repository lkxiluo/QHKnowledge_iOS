//
//  SpiderRouter.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/5/7.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

/// 路由的注册类型，path 为功能路径，target 路由目标
typealias RouterType = (path: String, targetName: String)
typealias RouterParams = [String: Any]
/// 路由桥接
class SpiderRouter {
    static let shared = SpiderRouter()
    
    // MARK: - Property
    /// 跳转路由集
    private var jumpRouters: [String : String] = [:]
    /// 事件响应路由集
    private var eventRouters: [String : [AnyObject & SpiderRouterEventProtocol]] = [:]
    /// 将要执行跳转的链接
    private var willPerformModels: [SpiderRouterModel] = []
    /// 是否已经完成注册
    private var isRegister = false
    private init() {
        DispatchQueue.global().async {
            self.registerRouters()
            self.isRegister = true
            DispatchQueue.main.async {
                for model in self.willPerformModels {
                    self.performJump(routerPath: model.path,
                                     animationType: model.translateMode,
                                     query: model.query)
                }
                self.willPerformModels.removeAll()
            }
        }
    }
    
    // MARK: - 设置路由配置
    func configScheme(scheme: String) {
        configScheme(scheme: scheme, jumpHost: "", eventHost: "")
    }
    
    func configScheme(scheme: String, jumpHost: String, eventHost: String) {
        if !scheme.isEmpty {
            SpiderRouterURLHelper.scheme = scheme
        }
        
        if !jumpHost.isEmpty {
            SpiderRouterURLHelper.jumpHost = jumpHost
        }
        
        if !eventHost.isEmpty {
            SpiderRouterURLHelper.eventHost = eventHost
        }
    }
    
    // MARK: - 跳转路由
    /// 执行 push 路由
    /// - Parameters:
    ///   - routerPath: 路由的路径
    ///   - query: 路由参数
    func performJump(routerPath: String,
                     animationType: TranslateMode = .push,
                     animated: Bool = true,
                     query: [String: Any]?) {
        guard isRegister else {
            let performModel = SpiderRouterModel.modelFromJumpPath(path: routerPath,
                                                                   queryDic: query)
            performModel.translateMode = animationType
            willPerformModels.append(performModel)
            return
        }
        
        var targetName = ""
        if let target = jumpRouters[routerPath] {
            targetName = target
        }
        
        guard let targetClass = NSClassFromString(targetName) as? SpiderRouterJumpProtocol.Type,
              targetClass.isCanJumpRouter(path: routerPath) else {
            return
        }
        
        let jumpModel = SpiderRouterModel.modelFromJumpPath(path: routerPath, queryDic: query)
        jumpModel.translateMode = animationType
        
        // 跳转至根 VC（pop）
        if targetClass.isRootRouter(path: routerPath),
           let tClass = targetClass as? UIViewController.Type {
            let targetVC = UIViewController.popToRootViewController(rootVCClass: tClass,
                                                                    animated: animated)
            targetVC?.rootHandle(routerModel: jumpModel)
            return
        }
        
        // push 跳转
        guard let targetVC = targetClass.createJumpRouterTarget(routerModel: jumpModel) else {
            return
        }
        
        if animationType == .present {
            targetVC.modalPresentationStyle = .fullScreen
            UIViewController.inViewController()?.present(targetVC,
                                                         animated: animated,
                                                         completion: nil)
        } else {
            UIViewController.inViewController()?.navigationController?.pushViewController(targetVC, animated: animated)
        }
    }
    
    /// 通过 URL 执行路由
    /// - Parameter url: 路由 URL
    func perFormURL(url: String) {
        let urlRouterModel = SpiderRouterModel.routerModelFromURL(url: url)
        if urlRouterModel.isEvent {
            performEvent(routerPath: urlRouterModel.path, query: urlRouterModel.query)
        } else {
            performJump(routerPath: urlRouterModel.path, query: urlRouterModel.query)
        }
    }
    
    // MARK: - 事件路由
    
    /// 注册路由事件，类似于通知的监听
    /// - Parameters:
    ///   - routerPath: 路由的 key
    ///   - target: 接收事件的对象
    func registerEventRouter(routerPath: String,
                             target: AnyObject & SpiderRouterEventProtocol) {
        guard !routerPath.isEmpty else {
            return
        }
        
        var isHaved: Bool = false
        if var eventObjs = eventRouters[routerPath] {
            for obj in eventObjs {
                if equateableAnyObject(object1: obj, object2: target) {
                    isHaved = true
                    break
                }
            }
            
            if !isHaved {
                eventObjs.append(target)
                eventRouters[routerPath] = eventObjs
            }
        } else {
            eventRouters[routerPath] = [target]
        }
    }
    
    /// 执行事件路由
    /// - Parameters:
    ///   - routerPath: 路由的路径
    ///   - query: 参数
    func performEvent(routerPath: String, query: [String: Any]?) {
        for (path, eventObjs) in eventRouters where path == routerPath {
            for obj in eventObjs {
                guard obj.isCanEventHandle(path: routerPath) else {
                    return
                }
                
                let eventModel = SpiderRouterModel.modelFromEventPath(path: routerPath, queryDic: query)
                
                obj.eventHandleWithRouterModel(routerModel: eventModel)
            }
        }
    }
    
    /// 移除注册路由事件，类似于通知的监听
    /// - Parameters:
    ///   - routerPath: 路由的 key
    ///   - target: 接收事件的对象
    func removeEventRouter(routerPath: String,
                           target: AnyObject & SpiderRouterEventProtocol) {
        guard var eventObjs = eventRouters[routerPath] else {
            return
        }
        
        for (index, obj) in eventObjs.enumerated() {
            if equateableAnyObject(object1: obj, object2: target) {
                eventObjs.remove(at: index)
                if eventObjs.isEmpty {
                    eventRouters.removeValue(forKey: routerPath)
                } else {
                    eventRouters[routerPath] = eventObjs
                }
                break
            }
        }
    }
    
    // MARK: - Private
    /// 注册所有路由
    private func registerRouters() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        
        for index in 0 ..< typeCount {
            let jumpRouterType = (types[index] as? SpiderRouterJumpProtocol.Type)?.registerJumpRouter()
            
            if let jumpRouter = jumpRouterType,
                findJumpRouterType(routerType: jumpRouter) == nil {
                jumpRouters[jumpRouter.path] = jumpRouter.targetName
            }
        }
        types.deallocate()
    }
    
    /// 查找跳转路由类型
    /// - Parameter routerType: 要找路由类型
    /// - Returns: 路由类型
    private func findJumpRouterType(routerType: RouterType) -> RouterType? {
        for (path, target) in jumpRouters where path == routerType.path && target == routerType.targetName {
            return routerType
        }
        return nil
    }
    
    /// 取出某个对象的地址
    func getAnyObjectMemoryAddress(object: AnyObject) -> String {
        let str = Unmanaged<AnyObject>.passUnretained(object).toOpaque()
        return String(describing: str)
    }
    
    /// 对比两个对象的地址是否相同
    private func equateableAnyObject(object1: AnyObject, object2: AnyObject) -> Bool {
        let str1 = getAnyObjectMemoryAddress(object: object1)
        let str2 = getAnyObjectMemoryAddress(object: object2)
        
        if str1 == str2 {
            return true
        } else {
            return false
        }
    }
}
