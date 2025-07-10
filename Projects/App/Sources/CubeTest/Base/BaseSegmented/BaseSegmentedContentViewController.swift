//
//  BaseSegmentedContentViewController.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//

import JXSegmentedView
import UIKit

class BaseSegmentedContentViewController: BaseViewController, JXSegmentedListContainerViewListDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func listView() -> UIView {
        return view
    }

    func listWillAppear() {
    }

    func listDidAppear() {
    }

    func listWillDisappear() {
    }

    func listDidDisappear() {
    }
}
