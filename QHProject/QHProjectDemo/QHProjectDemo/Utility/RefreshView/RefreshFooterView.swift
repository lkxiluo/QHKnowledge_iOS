//
//  RefreshFooterView.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/7/1.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation
import SnapKit

final class RefreshFooterView: MJRefreshAutoFooter {
    lazy private var activityIndicatorView: UIImageView = {
        let redLoadingImageView = UIImageView()
        redLoadingImageView.image = UIImage(named: "common_hud_reloading")
        redLoadingImageView.rotationAnimation()
        return redLoadingImageView
    }()
    
    // 上拉结束没有更多数据时的分割线条
    lazy private var noDataLineView1: UIView = {
        let view = UIView()
        view.backgroundColor = .c666666
        view.isHidden = true
        return view
    }()
    
    lazy private var noDataLineView2: UIView = {
        let view = UIView()
        view.backgroundColor = .c666666
        view.isHidden = true
        return view
    }()
    
    lazy private var noDataLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .c666666
        label.font = FontDesign.l12
        label.text = localizedString("QDM_Common_Refresh_NoData")
        return label
    }()
    
    override func prepare() {
        super.prepare()
        mj_h = 48.0        
        setupView()
        layout()
    }
    
    private func setupView() {
        addSubview(activityIndicatorView)
        addSubview(noDataLineView1)
        addSubview(noDataLineView2)
        addSubview(noDataLabel)
    }
    
    private func layout() {
        noDataLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        noDataLineView1.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.noDataLabel.snp.leading).offset(-4.0)
            make.centerY.equalTo(self.noDataLabel)
            make.height.equalTo(SizeDesign.splitLineHeight)
            make.width.equalTo(12.0)
        }
        
        noDataLineView2.snp.makeConstraints { (make) in
            make.leading.equalTo(self.noDataLabel.snp.trailing).offset(4.0)
            make.centerY.equalTo(self.noDataLabel)
            make.height.equalTo(SizeDesign.splitLineHeight)
            make.width.equalTo(12.0)
        }
        
        activityIndicatorView.snp.makeConstraints { (make) in
            make.width.height.equalTo(16.0)
            make.center.equalToSuperview()
        }
    }
    
    func setNoDataText(text: String) {
        noDataLabel.text = text
    }
    
    // 监听控件的刷新状态
    override var state: MJRefreshState {
        didSet {
            activityIndicatorView.isHidden = true
            noDataLabel.isHidden = true
            noDataLineView1.isHidden = true
            noDataLineView2.isHidden = true
            switch (state) {
            case .idle:
                activityIndicatorView.isHidden = true
            case .refreshing:
                activityIndicatorView.isHidden = false
            case .noMoreData:
                noDataLabel.isHidden = false
                noDataLineView1.isHidden = true
                noDataLineView2.isHidden = true
                activityIndicatorView.isHidden = true
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
