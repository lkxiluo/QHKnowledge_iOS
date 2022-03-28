//
//  RefreshHeaderView.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/7/1.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

final class RefreshHeaderView: MJRefreshHeader {
    lazy private var activityIndicatorView: UIImageView = {
        let redLoadingImageView = UIImageView()
        redLoadingImageView.image = UIImage(named: "common_hud_reloading")
        redLoadingImageView.rotationAnimation()
        return redLoadingImageView
    }()
    
    
    
    override func prepare() {
        super.prepare()
        mj_h = 56.0
        
        setupView()
        layout()
    }
    
    private func setupView() {
        addSubview(activityIndicatorView)
    }
    
    private func layout() {
        activityIndicatorView.snp.makeConstraints { (make) in
            make.width.height.equalTo(24.0)
            make.center.equalToSuperview()
        }
    }
    
    // 监听控件的刷新状态
    override var state: MJRefreshState {
        didSet {
            activityIndicatorView.isHidden = false
            switch (state) {
            case .idle:
                break
            case .pulling:
                break
            case .refreshing:
                break
            default:
                break
            }
        }
    }
    
    // 监听scrollView的contentOffset改变
    override func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentOffsetDidChange(change)
    }
     
    // 监听scrollView的contentSize改变
    override func scrollViewContentSizeDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentSizeDidChange(change)
    }
     
    // 监听scrollView的拖拽状态改变
    override func scrollViewPanStateDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewPanStateDidChange(change)
    }
}
