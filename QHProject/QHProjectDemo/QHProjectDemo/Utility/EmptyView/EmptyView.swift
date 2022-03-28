//
//  EmptyView.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/5/5.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

/// 空页面视图
final class EmptyView: UIView {
    // MARK: - Property
    // MARK: - datas
    private let emptyImageViewHeight = 180.0
    private var emptyImageOffsetY    = 100.0
    private let buttonHeight = 29.0
    var retryActionHandle: (() -> Void)?
    // MARK: - View
    private lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = FontDesign.m15
        label.textColor = .c666666
        return label
    }()
    
    private lazy var subDescriptionLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = FontDesign.r13
        label.textColor = .c666666
        return label
    }()
    
    private lazy var retryButton: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.titleLabel?.font = FontDesign.m13
        button.layer.cornerRadius = CGFloat(buttonHeight / 2)
        button.layer.masksToBounds = true
        button.setTitleColor(.cEF2F2F, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.cEF2F2F.cgColor
        button.layer.borderWidth = SizeDesign.borderWidth
        button.setTitle("重新刷新", for:.normal)
        button.setImage(UIImage(named: "common_right_redArrow"), for: .normal)
        button.addTarget(self, action: #selector(retryAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lift cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private func setupView() {
        addSubview(emptyImageView)
        addSubview(descriptionLabel)
        addSubview(subDescriptionLabel)
        addSubview(retryButton)
    }
    
    private func layout() {
        let vSpace = 72.0   // 横向间距
        let hSpace = 16.0   // 纵向间距
        emptyImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(emptyImageOffsetY)
            make.width.height.equalTo(emptyImageViewHeight)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.emptyImageView.snp_bottomMargin).offset(46.0)
            make.leading.equalToSuperview().offset(vSpace)
            make.trailing.equalToSuperview().offset(-vSpace)
        }
        
        subDescriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.descriptionLabel.snp_bottomMargin).offset(hSpace)
            make.leading.equalToSuperview().offset(vSpace)
            make.trailing.equalToSuperview().offset(-vSpace)
        }
        
        retryButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.subDescriptionLabel.snp_bottomMargin).offset(hSpace)
            make.centerX.equalTo(self.emptyImageView)
            make.height.equalTo(buttonHeight)
            make.width.equalTo(64.0)
        }
    }
    
    // MARK: - public
    func show(inSuperView: UIView?,
              offsetY: CGFloat?,
              bgColor: UIColor,
              retryActionHandle: (() -> Void)?) {
        guard let superView = inSuperView else {
            return
        }
        self.retryActionHandle = retryActionHandle
        backgroundColor = bgColor
        if superView.isKind(of: UIScrollView.self) {
            superView.superview?.addSubview(self)
            frame = superView.frame
        } else {
            superView.addSubview(self)
            frame = superView.bounds
        }
        
        let standardHeight = UIScreen.main.bounds.height - 88.0 - 49.0
        if let imageViewOffsetY = offsetY {
            emptyImageOffsetY = imageViewOffsetY
        }
        
        if frame.size.height < standardHeight {
            emptyImageView.snp.updateConstraints { (make) in
                make.top.equalToSuperview().offset(emptyImageOffsetY * Double(frame.size.height / standardHeight))
            }
        } else {
            emptyImageView.snp.updateConstraints { (make) in
                make.top.equalToSuperview().offset(emptyImageOffsetY)
            }
        }
    }
    
    // 隐藏空视图
    func hide() {
        guard (superview != nil) else {
            return
        }
        removeFromSuperview()
    }
    
    // 刷新显示数据
    func refreshData(emptyImage: UIImage?,
                     imageWidth: CGFloat?,
                     imageHeight: CGFloat?,
                     description: String?,
                     subDescription: String?,
                     buttonTitle: String?) {
        if (emptyImage != nil) {
            emptyImageView.image = emptyImage
        }
        
        if (imageWidth != nil) {
            emptyImageView.snp.updateConstraints { (make) in
                make.width.equalTo(imageWidth!)
            }
        }
        
        if imageHeight != nil {
            emptyImageView.snp.updateConstraints { (make) in
                make.height.equalTo(imageHeight!)
            }
        }
        
        descriptionLabel.text = description ?? ""
        subDescriptionLabel.text = subDescription ?? ""
        
        guard let title = buttonTitle, !title.isEmpty else {
            retryButton.isHidden = true
            return
        }
        retryButton.isHidden = false
        
        let font: UIFont! = FontDesign.m14
        let attributes = [NSAttributedString.Key.font:font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect: CGRect = title.boundingRect(with: CGSize(width: 220.0, height: 32.0),
                                              options: option,
                                              attributes: attributes as [NSAttributedString.Key : Any],
                                              context: nil)
        let buttonWidth = rect.size.width + 66.0
        retryButton.snp.updateConstraints { (make) in
            make.width.equalTo(buttonWidth)
        }
        layoutIfNeeded()
        setNeedsLayout()
        retryButton.setImageWithPosition(imagePosition: .right, space: 1.0)
    }
    
    // MARK: - Event
    // MARK: - -Action
    @objc func retryAction(sender: UIButton) {
        guard let callBackHandle = retryActionHandle else {
            return
        }
        callBackHandle()
    }
}
