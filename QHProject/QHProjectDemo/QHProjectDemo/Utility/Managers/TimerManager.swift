//
//  TimerManager.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/5/15.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation

/// 计时器滴答行走时间变更
let timerRuningTickChange = Notification.Name("timerRuningTick")
/// 定时器管理器
final class TimerManager {
    static let shared = TimerManager()
    /// 倒计时间隔，默认1秒
    var duration: TimeInterval = 1.0
    /// app 在后台运行的时间
    private var appBackgroundTimeInterval: TimeInterval = 0
    /// 进入后台的开始时间
    private var appBackgroundStartTime: TimeInterval = 0
    /// 倒计时执行次数
    private var timeIntervalTime: TimeInterval = 0
    /// 定时器事件对象的 key 和计时起始节点
    private var timerTargetDic: [String: TimeInterval] = [:]
    private var timer: Timer?
    private var thread: Thread?
    private init() {
    }

    private func addNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appBecomeInBack),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appBecomeToFront),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    private func removeNofitcation() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // MARK: - Event
    @objc private func timerRunAction() {
        timeIntervalTime += 1
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: timerRuningTickChange, object: nil)
        }
    }
    
    /// APP 进入后台
    @objc private func appBecomeInBack() {
        appBackgroundStartTime = Date().timeIntervalSince1970
    }
    
    /// APP 进入活跃状态
    @objc private func appBecomeToFront() {
        let appBackgroundEndTime = Date().timeIntervalSince1970
        appBackgroundTimeInterval = appBackgroundEndTime - appBackgroundStartTime
    }
    
    // MARK: - Public
    /// 开始定时对象的计时
    /// - Parameter targetkey: 定时对象事件的 key
    func startByTargetKey(targetkey: String?) {
        guard let key = targetkey, !key.isEmpty else {
            return
        }
        stopByTargetKey(targetkey: targetkey)
        timerTargetDic[key] = timeIntervalTime  // 设置该 key 计时开始的时间节点
        if timer == nil {
            thread = Thread(target: self, selector: #selector(subThreadRun), object: nil)
            thread?.start()
            addNotification()
        }
    }
    
    @objc private func subThreadRun() {
        self.timer = Timer.scheduledTimer(timeInterval: duration,
                                          target: self,
                                          selector: #selector(timerRunAction),
                                          userInfo: nil, repeats: true)
        RunLoop.current.run()
    }
    
    /// 结束定时对象的计时
    /// - Parameter targetkey: 定时对象事件的 key
    func stopByTargetKey(targetkey: String?) {
        guard let key = targetkey, !key.isEmpty else {
            return
        }
        timerTargetDic.removeValue(forKey: key)
        if timerTargetDic.count <= 0 {
            timeIntervalTime = 0
            timer?.invalidate()
            timer = nil
            thread?.cancel()
            thread = nil
            removeNofitcation()
        }
    }
    
    func realTimeIntervalForKey(targetKey: String?) -> TimeInterval {
        guard let key = targetKey, !key.isEmpty,
              !timerTargetDic.isEmpty,
              let startTimeInterval = timerTargetDic[key] else {
            return 0
        }
        
        timeIntervalTime += appBackgroundTimeInterval
        appBackgroundTimeInterval = 0
        return timeIntervalTime - startTimeInterval
    }
}
