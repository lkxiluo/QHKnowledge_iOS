//
//  EmptyViewManager.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/5/5.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

/// 空视图页面类型
enum EmptyViewType {
    case noData        // 空数据
    case netError      // 网络请求错误
    case other         // 其他类型
}

/// 空视图页面状态
enum EmptyViewStatus {
    case clear       // 清除空视图(隐藏)
    case noData      // 没加载到数据
    case netError    // 网络错误
    case other       // 其他状态
}

/// 空视图协议
protocol EmptyViewPrototol: AnyObject {
    /// 空白图标的 Y 起始值
    func emtpyImageOffsetY(type: EmptyViewType) -> CGFloat?
    /// 空页面要添加到的父视图
    func emptySuperView(type: EmptyViewType) -> UIView?
    /// 空页面图片
    func emptyImage(type: EmptyViewType) -> UIImage?
    /// 空视图描述，单行
    func emptyDescription(type: EmptyViewType) -> String?
    /// 空视图附件描述，多行
    func emptySubDescription(type: EmptyViewType) -> String?
    /// 按钮标题，为空时隐藏
    func emptyButtonTitle(type: EmptyViewType) -> String?
    /// 空视图图片宽度
    func emptyImageViewWidth(type: EmptyViewType) -> CGFloat?
    /// 空视图图片高度
    func emptyImageViewHeight(type: EmptyViewType) -> CGFloat?
    /// 按钮点击操作
    func emptyButtonActionHandle(type: EmptyViewType)
    /// 背景颜色
    func emptyBackgroudColor(type: EmptyViewType) -> UIColor?
    
    /// 自定义的空视图
    func emptyViewOfCustomer(type: EmptyViewType) -> UIView?
}

/// 空页面视图管理
final class EmptyViewManager {
    private static var allEmptyType: [EmptyViewType] {
        return [.noData, .netError, .other]
    }
    @discardableResult
    class func showInSuperView(offsetY: CGFloat?,
                               superView: UIView?,
                               emptyImage: UIImage?,
                               imageWidth: CGFloat?,
                               imageHeight: CGFloat?,
                               description: String?,
                               subDescription: String?,
                               buttonTitle: String?,
                               backgroundColor: UIColor?,
                               buttonActionHandle: (() -> Void)?) -> EmptyView {
        let emptyView = EmptyView()
        emptyView.show(inSuperView: superView,
                       offsetY: offsetY,
                       bgColor: backgroundColor ?? .white,
                       retryActionHandle: buttonActionHandle)
        emptyView.refreshData(emptyImage: emptyImage,
                              imageWidth: imageWidth,
                              imageHeight: imageHeight,
                              description: description,
                              subDescription: subDescription,
                              buttonTitle: buttonTitle)
        return emptyView
    }
    
    /// 显示空视图
    /// - Parameters:
    ///   - target: 实现了空白协议的对象
    ///   - emtpyType: 空白类型
    class func showInTarget(target: EmptyViewPrototol, emptyType: EmptyViewType) {
        hidenAllEmptyViewInTarget(target: target)
        
        // 自定义空白视图
        if let customEmptyView = target.emptyViewOfCustomer(type: emptyType) {
            let superView = target.emptySuperView(type: emptyType)
            superView?.addSubview(customEmptyView)
            return
        }
        
        // 协议配置空白视图
        let superView = target.emptySuperView(type: emptyType)
        let image = target.emptyImage(type: emptyType)
        let description = target.emptyDescription(type: emptyType)
        let subDescription = target.emptySubDescription(type: emptyType)
        let buttonTitle = target.emptyButtonTitle(type: emptyType)
        let imageWidth = target.emptyImageViewWidth(type: emptyType)
        let imageHeight = target.emptyImageViewHeight(type: emptyType)
        let bgColor = target.emptyBackgroudColor(type: emptyType)
        let offsetY = target.emtpyImageOffsetY(type: emptyType)
        
        showInSuperView(offsetY: offsetY,
                        superView: superView,
                        emptyImage: image,
                        imageWidth: imageWidth,
                        imageHeight: imageHeight,
                        description: description,
                        subDescription: subDescription,
                        buttonTitle: buttonTitle,
                        backgroundColor: bgColor) { [weak target] in
            guard let target = target else {
                return
            }
            target.emptyButtonActionHandle(type: emptyType)
        }
    }
    
    class func hidenAllEmptyViewInTarget(target: EmptyViewPrototol) {
        for type in allEmptyType {
            if var view = target.emptySuperView(type: type) {
                if view.isKind(of: UIScrollView.self) {
                    view = view.superview ?? UIView()
                }
                hidenAllEmptyViewInView(view: view)
            }
        }
    }
    
    class func hidenAllEmptyViewInView(view: UIView) {
        for subView in view.subviews {
            if subView.isKind(of: EmptyView.self) {
                subView.removeFromSuperview()
            }
        }
    }
}
