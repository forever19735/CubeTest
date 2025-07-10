//
//  RootViewController.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//

import UIKit

class RootViewController: BaseViewController {
    let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    override func setupUI() {
        setupStackView()
        addButtonsForRootTypes()
    }
}

private extension RootViewController {
    func setupStackView() {
        view.addSubview(stackView)

        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 16

        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

    func addButtonsForRootTypes() {
        for type in RootType.allCases {
            let button = UIButton(type: .system)
            button.setTitle(type.title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = 8

            button.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
            button.tag = type.hashValue

            stackView.addArrangedSubview(button)
        }
    }

    // MARK: - Button Action

    @objc func handleButtonTap(_ sender: UIButton) {
        guard let type = RootType.allCases.first(where: { $0.hashValue == sender.tag }) else {
            return
        }
        let vc = FriendRootViewViewController(viewModel: FriendViewModel(dataLoader: APIManager.shared, rootType: type))
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
}

enum RootType: CaseIterable {
    case noFriend
    case onlyFriendList
    case friendListAndInvitation

    var title: String {
        switch self {
        case .noFriend:
            return "無好友"
        case .onlyFriendList:
            return "只有好友列表"
        case .friendListAndInvitation:
            return "好友列表含邀請"
        }
    }

    var segmentedBackgroundColor: UIColor {
        switch self {
        case .noFriend, .onlyFriendList:
            return .clear
        case .friendListAndInvitation:
            return .white
        }
    }
}
