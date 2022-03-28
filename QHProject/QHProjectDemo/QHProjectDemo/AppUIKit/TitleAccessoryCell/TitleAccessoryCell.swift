//
//  TitleAccessoryCell.swift
//  带附视图的列表显示单元，示例样式：
/** (附视图部分可以自定义)
     _________________________________
    |                       |         |
    | 标题                   | 附标题 图|
    |_______________________|_________|
 
 */
//
//  Created by 罗坤 on 2021/7/22.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

protocol TitleAccessoryCellDelegate: AnyObject {
    /// 自定附视图
    /// - Parameter cell: 显示单元
    func customerAccessory(cell: TitleAccessoryCell, indexPath: IndexPath) -> UIView?
}

/// 带附视图的列表显示单元
class TitleAccessoryCell: UITableViewCell {
    private weak var delegate: TitleAccessoryCellDelegate?
    private var customerAccessoryView: UIView?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        selectionStyle = .none
        setupView()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configData(model: TitleAccessoryModel,
                    delegate: TitleAccessoryCellDelegate? = nil,
                    indexPath: IndexPath = IndexPath(item: 0, section: 0)) {
        configData(title: model.title,
                   accessoryTitle: model.accessoryTitle,
                   accessoryImage: model.accessoryImage,
                   delegate: delegate,
                   indexPath: indexPath)
        if let color = model.accessoryTitleColor {
            subTitleLabel.textColor = color
        }
    }
    
    /// 配置单元数据
    /// - Parameters:
    ///   - title: 标题
    ///   - accessoryTitle: 附视图标题
    ///   - accessoryImage: 附视图图片
    func configData(title: String?,
                    accessoryTitle: String? = nil,
                    accessoryImage: UIImage? = nil,
                    delegate: TitleAccessoryCellDelegate? = nil,
                    indexPath: IndexPath = IndexPath(item: 0, section: 0)) {
        self.delegate = delegate
        titleLabel.text = title
        subTitleLabel.text = accessoryTitle
        tagImageView.image = accessoryImage
        
        let imageSize: CGSize = accessoryImage?.size ?? .zero
        tagImageView.snp.updateConstraints { make in
            make.size.equalTo(imageSize)
        }
        
        if accessoryImage == nil {
            subTitleLabel.snp.updateConstraints { make in
                make.trailing.equalTo(tagImageView.snp.leading)
            }
        } else {
            subTitleLabel.snp.updateConstraints { make in
                make.trailing.equalTo(tagImageView.snp.leading).offset(-SizeDesign.spacing)
            }
        }
        
        if let customerView = self.delegate?.customerAccessory(cell: self, indexPath: indexPath) {
            if self.customerAccessoryView == nil {
                self.customerAccessoryView = customerView
                contentView.addSubview(self.customerAccessoryView!)
                self.customerAccessoryView?.snp.makeConstraints({ make in
                    make.trailing.equalToSuperview().offset(-SizeDesign.margin)
                    make.centerY.equalToSuperview()
                    make.size.equalTo(customerView.frame.size)
                })
            } else {
                self.customerAccessoryView = customerView
                self.customerAccessoryView?.snp.updateConstraints({ make in
                    make.size.equalTo(customerView.frame.size)
                })
            }
        } else {
            self.customerAccessoryView?.isHidden = (self.customerAccessoryView != nil)
        }
    }
    
    // MARK: - Private
    private func setupView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(tagImageView)
        contentView.addSubview(splitView)
    }
    
    private func layout() {
        splitView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(SizeDesign.margin)
            make.trailing.equalToSuperview().offset(-SizeDesign.margin)
            make.height.equalTo(SizeDesign.splitLineHeight)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(SizeDesign.margin)
        }
        
        let imageSize: CGSize = .zero
        tagImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-SizeDesign.margin)
            make.size.equalTo(imageSize)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(tagImageView.snp.leading).offset(-SizeDesign.spacing)
        }
    }
    
    // MARK: - Lazy
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontDesign.r15
        label.textColor = .c1A1A1A
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = FontDesign.r15
        label.textColor = .c666666
        label.textAlignment = .right
        return label
    }()
    
    private lazy var tagImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var splitView: UIView = {
        let view = UIView()
        view.backgroundColor = .cF2F2F2
        return view
    }()
}
