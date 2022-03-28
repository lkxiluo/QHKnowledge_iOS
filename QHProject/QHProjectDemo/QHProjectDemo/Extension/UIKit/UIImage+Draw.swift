//
//  UIImage+Draw.swift
//  QHProjectDemo
//
//  Created by 罗坤 on 2021/11/5.
//

import Foundation
import UIKit

extension UIImage {
    func drawImage(from color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
}
