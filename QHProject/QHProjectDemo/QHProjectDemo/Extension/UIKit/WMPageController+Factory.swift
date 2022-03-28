//
//  WMPageController+Factory.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/7/19.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation
import UIKit

extension WMPageController {
    func configSegmentedView() {
        titleColorNormal = .c999999
        titleColorSelected = .c1A1A1A
        titleSizeNormal = CGFloat(14.0)~
        titleSizeSelected = CGFloat(14.0)~
        titleFontName = FontDesign.fontMediumName
        menuView?.backgroundColor = .white
        progressHeight = 3.0
        progressViewCornerRadius = 1.5
        progressColor = .main
        automaticallyCalculatesItemWidths = true
        menuViewStyle = .line
    }
}
