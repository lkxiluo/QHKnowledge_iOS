//
//  BaseViewController.swift
//  基类 VC
//
//  Created by 罗坤 on 2021/4/26.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation
import UIKit

/// 基类 VC
class BaseViewController: UIViewController, EmptyViewPrototol {
    
    var needLogin: Bool? = false
    
    /// 空视图状态
    var emptyViewStatus: EmptyViewStatus = .clear {
        didSet {
            switch emptyViewStatus {
            case .clear:
                EmptyViewManager.hidenAllEmptyViewInTarget(target: self)
            case .noData:
                EmptyViewManager.showInTarget(target: self, emptyType: .noData)
            case .netError:
                EmptyViewManager.showInTarget(target: self, emptyType: .netError)
            case .other:
                EmptyViewManager.showInTarget(target: self, emptyType: .other)
            }
        }
    }
    
    // MARK: - Life cycle
    deinit {
        DLog("对象释放~~~ \(self)")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        systemVersionAdapter()
        addBackButton()
    }
    
    // MARK: - Private
    /// 系统版本适配
    private func systemVersionAdapter() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        if #available(iOS 11.0, *) {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    /// 初始化配置 
    private func setupViews() { 
        view.backgroundColor = .backgroud
        edgesForExtendedLayout = .init(rawValue: 0)
        fd_prefersNavigationBarHidden = false
    }
    
    /// 返回按钮
    private func addBackButton() {
        guard navigationController?.viewControllers.count ?? 0 > 1 else {
            return
        }
        let backBarItem = UIBarButtonItem(image: UIImage(named: "common_navigation_back"),
                                          landscapeImagePhone: .none,
                                          style: .plain,
                                          target: self,
                                          action: #selector(backAction))
        navigationItem.leftBarButtonItem = backBarItem
    }
    
    // MARK: - Event
    // MARK: - Action
    /// 返回操作
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - EmptyViewPrototol
    func emtpyImageOffsetY(type: EmptyViewType) -> CGFloat? {
        return 110.0
    }
    
    func emptySuperView(type: EmptyViewType) -> UIView? {
        return view
    }
    
    func emptyImage(type: EmptyViewType) -> UIImage? {
        switch type {
        case .noData:
            return UIImage(named: "empty_content")
        case .netError:
            return UIImage(named: "empty_netError")
        default:
            return UIImage(named: "empty_netError")
        }
    }
    
    func emptyDescription(type: EmptyViewType) -> String? {
        switch type {
        case .noData:
            return localizedString("Gree_Empty_Content")
        case .netError:
            return localizedString("Gree_Empty_NetError")
        default:
            return nil
        }
    }
    
    func emptySubDescription(type: EmptyViewType) -> String? {
        return nil
    }
    
    func emptyButtonTitle(type: EmptyViewType) -> String? {
        switch type {
        case .noData:
            return nil
        case .netError:
            return localizedString("QDM_Empty_Retry")
        default:
            return nil
        }
    }
    
    func emptyImageViewWidth(type: EmptyViewType) -> CGFloat? {
        var image = UIImage(named: "empty_netError")
        switch type {
        case .noData:
            image = UIImage(named: "empty_content")
        case .netError:
            image = UIImage(named: "empty_netError")
        default:
            image = UIImage(named: "empty_netError")
        }
        return image?.size.width ?? 107.0
    }
    
    func emptyImageViewHeight(type: EmptyViewType) -> CGFloat? {
        var image = UIImage(named: "empty_netError")
        switch type {
        case .noData:
            image = UIImage(named: "empty_content")
        case .netError:
            image = UIImage(named: "empty_netError")
        default:
            image = UIImage(named: "empty_netError")
        }
        return image?.size.height ?? 124.0
    }
    
    func emptyBackgroudColor(type: EmptyViewType) -> UIColor? {
        return .white
    }
    
    func emptyButtonActionHandle(type: EmptyViewType) {
        print("空白页点击操作~~~")
    }
    
    func emptyViewOfCustomer(type: EmptyViewType) -> UIView? {
        return nil
    }
}
