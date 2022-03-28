//
//  VerticalDoubleLabelItem.swift
//  竖向双行文字显示，示例：样式
/**
    ________
   |        |
   | 上文字  |
   | 下文字  |
   |________|
 */
//  Created by 罗坤 on 2021/7/14.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation
import SnapKit

/// 竖向双行文字显示
class VerticalDoubleLabelItemView: UIView {
    private var model: VerticalDoubleLabelItemModel?
    private override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func createItem(model: VerticalDoubleLabelItemModel) -> VerticalDoubleLabelItemView {
        let item = VerticalDoubleLabelItemView()
        item.model = model
        item.setupView()
        item.layout()
        item.config(model: model)
        return item
    }
    
    func config(model: VerticalDoubleLabelItemModel) {
        upLabel.textColor = model.upTitleColor
        upLabel.text = model.upTitle
        upLabel.font = model.upTitleFont
        if (model.upAttributText != nil) {
            upLabel.attributedText = model.upAttributText
        }
        
        downLabel.textColor = model.downTitleColor
        downLabel.text = model.downTitle
        downLabel.font = model.downTitleFont
        if (model.downAttributText != nil) {
            downLabel.attributedText = model.downAttributText
        }
    }
    
    open func addTarget(_ target: Any, action: Selector) {
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(target, action: action)
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - private
    private func setupView() {
        addSubview(upLabel)
        addSubview(downLabel)
    }
    
    private func layout() {
        guard let itemModel = model else {
            return
        }
        
        upLabel.textColor = itemModel.upTitleColor
        upLabel.text = itemModel.upTitle
        upLabel.font = itemModel.upTitleFont
        
        downLabel.textColor = itemModel.downTitleColor
        downLabel.text = itemModel.downTitle
        downLabel.font = itemModel.downTitleFont
        
        upLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY).offset(-itemModel.spacing / 2.0)
        }
        
        downLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.snp.centerY).offset(itemModel.spacing / 2.0)
        }
    }
    
    // MARK: - Lazy
    /// 上行
    private lazy var upLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    /// 下行
    private lazy var downLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
}
