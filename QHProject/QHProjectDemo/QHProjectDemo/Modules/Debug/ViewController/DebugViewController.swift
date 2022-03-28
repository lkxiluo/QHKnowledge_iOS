//
//  DebugVC.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/5/5.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation
import SnapKit
import SwiftyJSON

final class DebugViewController: BaseViewController {
    private lazy var debugTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        return tableView
    }()
    
    private var debugmVM = DebugViewModel()
    private var devEnrironment = RequestApiConfig.shared.getDevEnrironment()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "调试环境设置"
        let sureButton = UIButton(type: .custom)
        sureButton.setTitle("切换", for: .normal)
        sureButton.setTitleColor(.black, for: .normal)
        sureButton.frame = CGRect(x: 0.0, y: 0.0, width: 64.0, height: 44.0)
        sureButton.addTarget(self, action: #selector(changeEnvironment), for: .touchUpInside)
        let sureBarItem: UIBarButtonItem = UIBarButtonItem(customView: sureButton)
        navigationItem.rightBarButtonItem = sureBarItem
        
        setupView()
        layout()
    }
    
    // MARK: - Private
    private func setupView() {
        view.addSubview(debugTableView)
        debugTableView.mj_header = RefreshHeaderView(refreshingBlock: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                guard let `self` = self else {
                    return
                }
                self.debugTableView.mj_header?.endRefreshing()
            }
        })
        
        debugTableView.mj_footer = RefreshFooterView(refreshingBlock: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                guard let `self` = self else {
                    return
                }
                self.debugTableView.mj_footer?.endRefreshingWithNoMoreData()
            }
        })
    }
    
    private func layout() {
        debugTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Event
    // MARK: - Action
    @objc func changeEnvironment() {
        DLog("切换环境 \(Thread.isMainThread)")
        RequestApiConfig.shared.devEnrironment = devEnrironment
        // TODO:退出登录，清除登录、用户信息
        navigationController?.popToRootViewController(animated: true)
    }
}

extension DebugViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return debugmVM.debugModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard debugmVM.debugModels.count > 0 else {
            return 0
        }
        let sectionModel = debugmVM.debugModels[section]
        return sectionModel.sectionRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self)) ?? UITableViewCell()
        cell.selectionStyle = .none
        
        let sectionModel = debugmVM.debugModels[indexPath.section]
        let rowModel = sectionModel.sectionRows[indexPath.row]
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: 18.0, height: 18.0)
        cell.accessoryView = imageView
        cell.textLabel?.text = rowModel.title
        if rowModel.image != nil {
            imageView.image = rowModel.image
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionModel = debugmVM.debugModels[indexPath.section]
        let rowModel = sectionModel.sectionRows[indexPath.row]
        return CGFloat(rowModel.rowHeight)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .cF2F2F2
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 8.0, y: 0.0, width: 220.0, height: 36.0)
        headerView.addSubview(titleLabel)
        
        guard debugmVM.debugModels.count > 0 else {
            return headerView
        }
        let sectionModel = debugmVM.debugModels[section]
        titleLabel.text = sectionModel.sectionTitle
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionModel = debugmVM.debugModels[indexPath.section]
        let rowModel = sectionModel.sectionRows[indexPath.row]
        if rowModel.value is RequestDevEnrironment {
            devEnrironment = rowModel.value as! RequestDevEnrironment
            setSectionImages(indexPath: indexPath)
        } else if rowModel.value is String {
            Router.performJump(routerPath: rowModel.value as! String, query: [:])
        } else {
            DLog("输入的类型有错误。。。")
        }
        tableView.reloadData()
    }
    
    func setSectionImages(indexPath: IndexPath) {
        var tmpSectionModel = DebugSectionModel()
        let sectionModel = debugmVM.debugModels[indexPath.section]
        tmpSectionModel.sectionTitle = sectionModel.sectionTitle
        
        for index in 0..<sectionModel.sectionRows.count {
            var rowModel = sectionModel.sectionRows[index]
            if rowModel.value is RequestDevEnrironment,
               rowModel.value as! RequestDevEnrironment == devEnrironment {
                rowModel.image = UIImage(named: "common_check_selected")
            } else {
                rowModel.image = nil
            }
            tmpSectionModel.sectionRows.append(rowModel)
        }
        
        debugmVM.debugModels.remove(at: indexPath.section)
        debugmVM.debugModels.insert(tmpSectionModel, at: indexPath.section)
    }
}

extension DebugViewController: SpiderRouterJumpProtocol {
    static func registerJumpRouter() -> RouterType {
        return (RouterJumpPath.debugApi, NSStringFromClass(DebugViewController.self))
    }
    
    static func isCanJumpRouter(path: String) -> Bool {
        return path == RouterJumpPath.debugApi
    }
    
    static func createJumpRouterTarget(routerModel: SpiderRouterModel) -> UIViewController? {
        DLog("\(String(describing: routerModel.query))")
        let debugVC = DebugViewController()
        return debugVC
    }
}
