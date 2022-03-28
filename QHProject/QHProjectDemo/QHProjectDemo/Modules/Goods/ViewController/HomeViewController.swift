//
//  HomeVC.swift
//  QdamaECMall
//
//  Created by 罗坤 on 2021/8/21.
//  Copyright © 2021 Qdama. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

final class HomeViewController: BaseViewController {
    var refreshHandle: (()->Void)?
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(testButton)
        testButton.snp.makeConstraints { make in
            make.leading.top.equalTo(24.0)
            make.width.equalTo(96.0)
            make.height.equalTo(44.0)
        }
    }
    
    // MARK: - Action
    @objc private func debugAction() {
        Router.performJump(routerPath: RouterJumpPath.debugApi, query: [:])
    }
    
    // MARK: - Lazy
    private var testButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Debug", for: .normal)
        btn.setTitleColor(.c1A1A1A, for: .normal)
        btn.backgroundColor = .white
        btn.layer.borderWidth = SizeDesign.borderWidth
        btn.layer.borderColor = UIColor.c1A1A1A.cgColor
        btn.layer.cornerRadius = 4.0
        btn.addTarget( self, action: #selector(debugAction), for: .touchUpInside)
        return btn
    }()
}

struct TestMirrorModel {
    var name: String?
    var age: Int?
}
