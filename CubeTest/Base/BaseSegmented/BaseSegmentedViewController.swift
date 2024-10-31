//
//  BaseSegmentedViewController.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//

import JXSegmentedView
import SnapKit
import UIKit

class BaseSegmentedViewController: BaseViewController {
    var SEGMENTED_VIEW_HEIGHT: CGFloat { 44 }

    let dataSource = JXSegmentedNumberDataSource()
    let segmentedView = JXSegmentedView()
    lazy var segmentedListContainerView: JXSegmentedListContainerView = {
        JXSegmentedListContainerView(dataSource: self)
    }()

    var segmentedTopConstraintTarget: ConstraintRelatableTarget { view.safeAreaLayoutGuide }
    var segmentedBottomConstraintTarget: ConstraintRelatableTarget { view.safeAreaLayoutGuide }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension BaseSegmentedViewController {

    func initSegmentedView(titles: [String], backgroundColor: UIColor) {
        dataSource.isItemSpacingAverageEnabled = false
        dataSource.itemSpacing = 36
        // Assign data source
        dataSource.titleNormalFont = UIFont.font(.pingFangRegular, fontSize: 13)
        dataSource.titleNormalColor = .greyishBrown
        dataSource.titleSelectedFont = UIFont.font(.pingFangMedium, fontSize: 13)
        dataSource.titleSelectedColor = .greyishBrown
        dataSource.numberBackgroundColor = UIColor(hex: "#f9b2dc")
        dataSource.numberOffset = CGPoint(x: 13, y: 2)
        dataSource.numbers = [0,0]
        dataSource.titles = titles
        dataSource.numberStringFormatterClosure = {(number) -> String in
            if number > 99 {
                return "99+"
            }
            return "\(number)"
        }

        // Assign indicator
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorHeight = 4
        indicator.indicatorWidth = 20
        indicator.indicatorColor = .hotPink
        
        // Setup segmentedView
        segmentedView.backgroundColor = backgroundColor
        segmentedView.dataSource = dataSource
        segmentedView.indicators = [indicator]
        segmentedView.listContainer = segmentedListContainerView
        segmentedView.delegate = self
    }
}


extension BaseSegmentedViewController: JXSegmentedListContainerViewDataSource, JXSegmentedViewDelegate {

    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return dataSource.titles.count
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return BaseSegmentedContentViewController()
    }

    @objc func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        // override this method
    }
}
