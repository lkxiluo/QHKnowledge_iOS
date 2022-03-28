//
//  UICollectionView+Extension.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/6/2.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

/**
 UICollectionView 扩展集
 */

// MARK: - 初始化
extension UICollectionView {
   
}

// MARK: - 行为操作
extension UICollectionView {
    /// 重新刷新
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    
    /// 判断当前单元是否可用
    func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.section >= 0 &&
            indexPath.item >= 0 &&
            indexPath.section < numberOfSections &&
            indexPath.item < numberOfItems(inSection: indexPath.section)
    }
}
