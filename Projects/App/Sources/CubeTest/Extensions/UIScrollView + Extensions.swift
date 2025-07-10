//
//  UIScrollView + Extensions.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//
import Foundation
import MJRefresh

extension UIScrollView {
    func addRefreshHeader(target: Any, selector: Selector) {
        let refreshHeader = MJRefreshNormalHeader(refreshingTarget: target, refreshingAction: selector)
        refreshHeader.lastUpdatedTimeLabel?.isHidden = true
        refreshHeader.stateLabel?.isHidden = true
        mj_header = refreshHeader
    }
}
