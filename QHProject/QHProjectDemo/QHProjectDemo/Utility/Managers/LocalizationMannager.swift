//
//  LocalizationMannager.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/5/5.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

fileprivate let currentLocalized  = "currentLocalized"
/// 国际化管理
final class LocalizationMannager {
    /// 当前语言编码，默认英语
    var languageCode: String = "en"
    /// 当前语言名，默认英语
    var languageName: String = "English"
    /// 是否在 app 内切换
    var isAppNative: Bool = false
    /// APP 设置支持的语言集合
    var languageList = [String]()
    
    static let share = LocalizationMannager()
    private init() {
        configLanguageCode()
    }
    
    func setLanguageCode(_ code: String) {
        languageCode = code
        let userDefault = UserDefaults.standard
        userDefault.set(code, forKey: currentLocalized)
    }
    
    func localizedForKey(_ key: String) -> String {
        guard let bundlePath = Bundle.main.path(forResource: languageCode, ofType: "lproj") else {
            return NSLocalizedString(key, comment: "")
        }
        
        guard let bundle = Bundle.init(path: bundlePath) else {
            return NSLocalizedString(key, comment: "")
        }
        let stringInTable = NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "")
        return stringInTable
    }
    
    /// 配置语言
    fileprivate func configLanguageCode() {
        if isSetAppNative() {
            let userDefault = UserDefaults.standard
            languageCode = userDefault.string(forKey: currentLocalized)!
        }
        nativeLanguageList()
    }
    
    /// 读取 APP 内适配的语言列表
    fileprivate func nativeLanguageList() {
        let fileArray = Bundle.main.paths(forResourcesOfType: "lproj", inDirectory: nil)
        var languageArray = [String]()
        var systemLanguageCode = String()
        if NSLocale.preferredLanguages.isEmpty {
            let language = NSLocale.preferredLanguages.first ?? "en"
            let index = language.index(language.startIndex, offsetBy: 2)
            systemLanguageCode = String(language[..<index])
        } else {
            systemLanguageCode = NSLocale.current.currencyCode ?? "en"
        }
        
        var isExit = false
        for fileName in fileArray {
            let index1   = fileName.index(fileName.endIndex, offsetBy: -8)
            let index2   = fileName.index(fileName.endIndex, offsetBy: -6)
            let langCode = String(fileName[index1..<index2])
            if langCode == systemLanguageCode {
                isExit = true
            }
            languageArray.append(langCode)
        }
        
        if !isSetAppNative() {
            languageCode = isExit ? systemLanguageCode : languageCode
        }
        languageList = languageArray
    }
    
    fileprivate func isSetAppNative() -> Bool {
        let userDefault = UserDefaults.standard
        return (userDefault.string(forKey: currentLocalized) != nil && isAppNative)
    }
}
