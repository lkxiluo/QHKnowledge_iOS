//
//  ResponseCache.swift
//  网络请求返回值缓存
//
//  Created by 罗坤 on 2021/6/4.
//  Copyright © 2021 QHProject. All rights reserved.
//  网络请求返回值缓存

import Foundation
import Cache

/// 缓存 key 值设置
public struct CacheKey {
    /// 将参数、url 进行 MD5 加密作为缓存的键，即请求的可唯一标识加密成缓存关键字
    static func cacheKey(url: String,
                         parameters: [String: Any]?,
                         commomParameters: [String: Any]?) -> String {
        var resultKey: String = ""
        if let params = parameters?.filter({ (key, _) -> Bool in
            return commomParameters?.contains(where: { (key1, _) -> Bool in return key != key1 }) ?? false
        }) {
            let str = "\(url)" + sort(parameters: params)
            resultKey = MD5(str)
        } else {
            resultKey = MD5(url)
        }
        return resultKey
    }
    
    /// 将参数降序转成字符串
    static func sort(parameters: [String: Any]?) -> String {
        var result: String = ""
        if let params = parameters {
            let sortKeyArray = params.keys.sorted { $0 < $1 }
            sortKeyArray.forEach { (key) in
                if let value = params[key] {
                    result = result.appending("\(key)=\(value)")
                } else {
                    result = result.appending("\(key)=")
                }
            }
        }
        return result
    }
}

// MARK: 缓存过期参数
/// 缓存类型设置
public enum CacheExpiry {
    /// 永不过期（68 年），见 Expiry.never
    case never
    /// 设置多少秒后过期
    case seconds(TimeInterval)
    /// 到哪个日期过期
    case date(Date)
    /// 设置多少秒内只读缓存
    case onlyResponseCache(TimeInterval)
    /// 不缓存
    case none
    
    /// Cache 的过期对象
    public var expired: Expiry {
        switch self {
        case .never: return Expiry.never
        case .seconds(let time): return Expiry.seconds(time)
        case .date(let data): return Expiry.date(data)
        case .none: return Expiry.seconds(-100)
        case .onlyResponseCache(let time): return Expiry.seconds(time)
        }
    }
}

// MARK: 缓存的对象模型
public struct CacheModel: Codable {
    var data: Data?
//    var response: Dictionary<String, Data>?
    init() { }
}

// MARK: 缓存管理器
public class ResponseCache: NSObject {
    /// 缓存的路径文件夹名
    private let cacheFolderName = "QHProjectResponseCache"
    /// 缓存索引的保存键
    private let cacheIndexSaveKey = "CacheIndexKey"
    /// 缓存键的保存键
    private let cacheKeySaveKey = "CacheKeySaveKey"
    
    static let `default` = ResponseCache()
    /// 缓存管理对象
    private var storage: Storage<CacheModel>?
    /// 最大的缓存数，默认是 30 个网络请求返回的数据，如果小于等 0 时，则没有计数限制
    private lazy var maxStorage: UInt = {
        return 30
    }()
    
    /// 缓存 key 对应的索引
    private var indexOfCacheKey: [String: Int] = [:]
    /// 缓存的 key
    private var cacheKeys: [String] = []
    private let userDefaults = UserDefaults.standard
    
    var expired: CacheExpiry = .never
    private override init() {
        super.init()
        config()
    }
    
    // MARK: - Public
    /// 缓存配置
    func config(expired: CacheExpiry = .never) {
        self.expired = expired
        let diskConfig = DiskConfig(name: cacheFolderName, expiry: expired.expired)
        let memoryConfig = MemoryConfig(expiry: expired.expired, countLimit: maxStorage)
        getOperationRecord()
        do {
            storage = try Storage(diskConfig: diskConfig,
                                  memoryConfig: memoryConfig,
                                  transformer: TransformerFactory.forCodable(ofType: CacheModel.self))
            try removeExpiredObjects()
        } catch {
            DLog(error)
        }
    }
    
    /// 保存缓存对象
    func addCacheModel(object: CacheModel, for cacheKey: String, expiry: Expiry) {
        /// 当 maxStorage <= 0 时，不做缓存限制
        if (maxStorage <= 0) {
            indexOfCacheKey.removeAll()
            cacheKeys.removeAll()
            setObject(object: object, for: cacheKey, expiry: expiry)
            return
        }
        
        let index: Int? = indexOfCacheKey[cacheKey]
        // 已存在，更换位置
        if let tmpIdnex = index {
            cacheKeys.remove(at: tmpIdnex)
            cacheKeys.insert(cacheKey, at: 0)
        } else {
            // 大于缓存上限，淘汰最后一个
            if cacheKeys.count >= maxStorage {
                let lastKey = cacheKeys.last
                indexOfCacheKey.removeValue(forKey: lastKey ?? "")
                cacheKeys.removeLast()
                cacheKeys.insert(cacheKey, at: 0)
                removeObject(for: lastKey ?? "") { (isSuccess) in
                    DLog(isSuccess)
                }
            } else {
                cacheKeys.insert(cacheKey, at: 0)
            }
        }
        
        setObject(object: object, for: cacheKey, expiry: expiry)
        resetKeyIndex()
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else {
                return
            }
            self.saveOperationRecord()
        }
    }
    
    func isExpiry(for cacheKey: String) -> Bool {
        do {
            if let isExpiry = try storage?.isExpiredObject(forKey: cacheKey), isExpiry {
                return true
            }
        } catch {
            return false
        }
        return false
    }
    
    /// 清除所有缓存，同步
    func removeAll() throws {
        cacheKeys.removeAll()
        indexOfCacheKey.removeAll()
        try storage?.removeAll()
    }
    
    // MARK: - Private
    /// 设置缓存，异步
    func setObject(object: CacheModel, for key: String, expiry: Expiry) {
        storage?.async.setObject(object, forKey: key, expiry: expiry, completion: { (result) in
            switch result {
            case .value(let obj):
                DLog("缓存成功：\(obj)")
            case .error(let error):
                DLog("缓存失败：\(error)")
            }
        })
    }
    
    /// 根据键移除缓存，异步
    func removeObject(for key: String, completeHandle:@escaping (_ isSuccess: Bool) -> Void) {
        storage?.async.removeObject(forKey: key, completion: { [weak self] (result) in
            switch result {
            case .value(let value):
                DLog("移除缓存内容：\(value)")
                completeHandle(true)
                guard let `self` = self else {
                    return
                }
                if let index = self.indexOfCacheKey[key] {
                    self.cacheKeys.remove(at: index)
                    self.indexOfCacheKey.removeValue(forKey: key)
                }
            case .error(let error):
                DLog("移除缓存错误: \(error)")
                completeHandle(false)
            }
        })
    }
    
    /// 移除所有缓存，异步
    func removeAllObject(completeHandle:@escaping (_ isSuccess: Bool) -> Void) {
        storage?.async.removeAll(completion: { [weak self] (result) in
            switch result {
            case .value(let value):
                DLog("移除所有缓存内容：\(value)")
                completeHandle(true)
                guard let `self` = self else {
                    return
                }
                self.cacheKeys.removeAll()
                self.indexOfCacheKey.removeAll()
            case .error(let error):
                DLog("移除所有缓存错误: \(error)")
                completeHandle(false)
            }
        })
    }
    
    /// 读取缓存数据，同步
    func cacheObject(for key: String) -> CacheModel? {
        do {
            // 当缓存过期时清除
            if let isExpiry = try storage?.isExpiredObject(forKey: key), isExpiry {
                removeObject(for: key) { (_) in }
                return nil
            } else {
                return (try storage?.object(forKey: key)) ?? nil
            }
        } catch {
            return nil
        }
    }

    /// 移除过期的缓存
    private func removeExpiredObjects() throws {
        for cacheKey in cacheKeys {
            if isExpiry(for: cacheKey), let index = indexOfCacheKey[cacheKey] {
                cacheKeys.remove(at: index)
                indexOfCacheKey.removeValue(forKey: cacheKey)
            }
        }
        try storage?.removeExpiredObjects()
    }
    
    /// 重置缓存 key 索引
    private func resetKeyIndex() {
        for (index, cacheKey) in cacheKeys.enumerated() {
            DLog("\(cacheKey): \(index)")
            indexOfCacheKey[cacheKey] = index
        }
    }
    
    /// 保存缓存操作记录
    private func saveOperationRecord() {
        userDefaults.setValue(indexOfCacheKey, forKey: cacheIndexSaveKey)
        userDefaults.setValue(cacheKeys, forKey: cacheKeySaveKey)
        userDefaults.synchronize()
    }
    
    /// 获取缓存操作记录
    private func getOperationRecord() {
        let tmpIndexOfCacheKey = userDefaults.object(forKey: cacheIndexSaveKey)
        let tmpCacheKeys = userDefaults.object(forKey: cacheKeySaveKey)
        if tmpIndexOfCacheKey != nil, tmpIndexOfCacheKey is [String: Int] {
            indexOfCacheKey = tmpIndexOfCacheKey as! [String : Int]
        }
        
        if tmpCacheKeys != nil, tmpCacheKeys is [String] {
            cacheKeys = tmpCacheKeys as! [String]
        }
    }
}
