//
//  DebugLog.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/5/5.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation
import SwiftyJSON

/// 日志打印
func DLog<T>(_ message: T, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm:ss.SSS"
    let dateString = dateFormatter.string(from: Date())
    print("[时间]\(dateString)\n[文件]\(fileName)\n[函数]\(funcName)\n[行号]\(lineNum)\n[信息]\(message)\n")
    #endif
}
