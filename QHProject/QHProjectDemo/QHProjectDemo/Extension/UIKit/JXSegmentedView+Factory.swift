//
//  JXSegmentedView+Factory.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/7/16.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation
import JXSegmentedView

extension JXSegmentedView {
    private struct AssociatedKey {
        static var dataSourceKey: String = "dataSourceKey"
        static var indicatorKey: String = "indicatorKey"
    }
    
    private var kdataSource: JXSegmentedTitleDataSource {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.dataSourceKey)
                as? JXSegmentedTitleDataSource ?? JXSegmentedTitleDataSource()
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.dataSourceKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var kindicator: JXSegmentedIndicatorLineView {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.indicatorKey)
                as? JXSegmentedIndicatorLineView ?? JXSegmentedIndicatorLineView()
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.indicatorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func configSegmentedView(titles: [String]) {
        let tmpDataSource = JXSegmentedTitleDataSource()
        tmpDataSource.isTitleColorGradientEnabled = false
        tmpDataSource.titleNormalFont = FontDesign.r14
        tmpDataSource.titleSelectedFont = FontDesign.m14
        tmpDataSource.titleNormalColor = .c999999
        tmpDataSource.titleSelectedColor = .c1A1A1A
        tmpDataSource.titles = titles
        kdataSource = tmpDataSource
        
        let tmpIndicator = JXSegmentedIndicatorLineView()
        tmpIndicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        tmpIndicator.indicatorHeight = 3.0
        tmpIndicator.indicatorCornerRadius = 1.5
        tmpIndicator.indicatorColor = .main
        kindicator = tmpIndicator
        
        self.dataSource = kdataSource
        self.indicators = [kindicator]
        self.backgroundColor = .white
    }
}
