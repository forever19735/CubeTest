//
//  FriendRootViewViewController.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//

import JXSegmentedView
import SnapKit
import UIKit

class FriendRootViewViewController: BaseSegmentedViewController {
    private lazy var topContainerView: UIView = {
        let view = UIView()
        return view
    }()

    private let userInfoView: UserInfoView = {
        let view = UserInfoView()
        return view
    }()

    private let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#efefef")
        return view
    }()

    private lazy var friendInviteVC: FriendInviteViewController = {
        let viewController = FriendInviteViewController(viewModel: viewModel)
        return viewController
    }()

    private lazy var containerVC: [JXSegmentedListContainerViewListDelegate] = [
        FriendListViewController(viewModel: viewModel),
        ChatViewController(),
    ]

    private let titles = ["好友", "聊天"]

    private var topContainerTopConstraint: Constraint?

    private var originalTopConstant: CGFloat = 0

    private let viewModel: FriendViewModel
    init(viewModel: FriendViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getUserInfo()
        viewModel.fetchFriendListBasedOnRootType()
        binding()
        setupSegmentedView()
        setupNavigationBar(title: nil)
    }

    override func setupUI() {
        view.backgroundColor = .whiteTwo
        view.addSubview(topContainerView)
        topContainerView.addSubviews([userInfoView, segmentedView, bottomLineView])

        topContainerView.snp.makeConstraints { make in
            topContainerTopConstraint = make.top.equalTo(self.view.safeArea.top).constraint
            make.left.right.equalToSuperview()
        }

        userInfoView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }

        if viewModel.rootType == .friendListAndInvitation {
            topContainerView.addSubview(friendInviteVC.view)
            friendInviteVC.view.snp.makeConstraints { make in
                make.top.equalTo(userInfoView.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(200)
            }

            segmentedView.snp.makeConstraints { make in
                make.top.equalTo(friendInviteVC.view.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(SEGMENTED_VIEW_HEIGHT)
            }
        } else {
            segmentedView.snp.makeConstraints { make in
                make.top.equalTo(userInfoView.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(SEGMENTED_VIEW_HEIGHT)
            }
        }

        bottomLineView.snp.makeConstraints { make in
            make.top.equalTo(segmentedView.snp.bottom)
            make.height.equalTo(1)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        view.addSubview(segmentedListContainerView)
        segmentedListContainerView.snp.makeConstraints { make in
            make.top.equalTo(topContainerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        // 保存原始位置
        originalTopConstant = 0
    }
}

private extension FriendRootViewViewController {
    func setupSegmentedView() {
        initSegmentedView(titles: titles,
                          backgroundColor: viewModel.rootType.segmentedBackgroundColor)

        let listVC = containerVC[segmentedView.selectedIndex] as? FriendListViewController
        listVC?.delegate = self
    }

    func animateTopViewsToNavigationBar() {
        let targetConstant: CGFloat = -(topContainerView.frame.height)
        topContainerTopConstraint?.update(offset: targetConstant)

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    func resetTopViewsPosition() {
        topContainerTopConstraint?.update(offset: originalTopConstant)

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    func updateSegmentedViewNumbers(with response: [FriendListResponse]) {
        let invitingFriends = response.filter { $0.status == .inviting }
        let chatFriendsCount = viewModel.rootType == .noFriend ? 0 : 100
        dataSource.numbers = [invitingFriends.count, chatFriendsCount]
        segmentedView.reloadData()
    }
}

private extension FriendRootViewViewController {
    func binding() {
        viewModel
            .$userInfoResponse
            .sink { [weak self] response in
                let userInfo = response.first
                let viewData = UserInfoViewData(
                    name: userInfo?.name,
                    id: "KOKO ID：\(userInfo?.kokoid ?? "")"
                )
                self?.userInfoView.configure(viewData: viewData)
            }
            .store(in: &cancellables)
        viewModel.$friendListResponse
            .dropFirst()
            .sink { [weak self] response in
                self?.updateSegmentedViewNumbers(with: response)
            }
            .store(in: &cancellables)
    }
}

extension FriendRootViewViewController {
    override func listContainerView(_: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return containerVC[index]
    }
}

extension FriendRootViewViewController: FriendListViewDelegate {
    func searchBarDidBeginEditing() {
        animateTopViewsToNavigationBar()
    }

    func didchangeSearchText(_ text: String) {
        if text.isEmpty {
            resetTopViewsPosition()
        } else {
            animateTopViewsToNavigationBar()
        }
    }
}
