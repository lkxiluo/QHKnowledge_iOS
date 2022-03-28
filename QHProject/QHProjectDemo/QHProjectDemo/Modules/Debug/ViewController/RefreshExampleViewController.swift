//
//  RefreshExampleVC.swift
//  QHProjectECMall
//
//  Created by 罗坤 on 2021/7/6.
//  Copyright © 2021 QHProject. All rights reserved.
//

import Foundation
import SnapKit

final class RefreshExampleViewController: BaseViewController {
    private let maxData = 50
    private var data = 0
    private lazy var refreshTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.tableFooterView = UIView()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        tableView.estimatedRowHeight = 48.0
        tableView.contentInset = UIEdgeInsets(top: 0.0,
                                              left: 0.0,
                                              bottom: SystemDesign.iPhoneXBottomHeihgt,
                                              right: 0.0)
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "上下拉刷新"
        setupView()
        layout()
        configRefresh()
    }
    
    private func setupView() {
        view.addSubview(refreshTableView)
    }
    
    private func layout() {
        refreshTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configRefresh() {
        refreshTableView.mj_header = RefreshHeaderView(refreshingBlock: { [weak self] in
            guard let `self` = self else {
                return
            }
            self.data = 10
            self.refreshTableView.mj_header?.endRefreshing()
            if self.data >= self.maxData {
                self.refreshTableView.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.refreshTableView.mj_footer?.endRefreshing()
            }
            self.refreshTableView.reloadData()
        })
        
        refreshTableView.mj_footer = RefreshFooterView(refreshingBlock: { [weak self] in
            guard let `self` = self else {
                return
            }
            
            self.data += 10
            if self.data < self.maxData {
                self.refreshTableView.mj_footer?.endRefreshing()
            } else {
                self.refreshTableView.mj_footer?.endRefreshingWithNoMoreData()
            }
            self.refreshTableView.reloadData()
        })
    }
}

extension RefreshExampleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self))!
        cell.selectionStyle = .none
        cell.textLabel?.text = "IndexPath of section \(indexPath.section) row \(indexPath.row)"
        return cell
    }
}

extension RefreshExampleViewController: SpiderRouterJumpProtocol {
    static func registerJumpRouter() -> RouterType {
        return (RouterJumpPath.debugRefresh, NSStringFromClass(RefreshExampleViewController.self))
    }
    
    static func isCanJumpRouter(path: String) -> Bool {
        return path == RouterJumpPath.debugRefresh
    }
    
    static func createJumpRouterTarget(routerModel: SpiderRouterModel) -> UIViewController? {
        let refreshVC = RefreshExampleViewController()
        return refreshVC
    }
}

