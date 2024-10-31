//
//  FriendSearchView.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//

import UIKit

protocol FriendSearchViewDelegate: AnyObject {
    func didChangeSearchText(_ text: String)
    func searchBarDidBeginEditing()
}

class FriendSearchView: UIView {
    weak var delegate: FriendSearchViewDelegate?
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "想轉一筆給誰呢？"
        searchBar.barTintColor = .white
        searchBar.tintColor = .steel
        searchBar.searchTextField.font = UIFont.font(.pingFangRegular, fontSize: 14)
        searchBar.delegate = self
        return searchBar
    }()

    private let addFriendsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(asset: .iconAddFriends), for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
    }

}

private extension FriendSearchView {
    func setupConstraints() {
        addSubviews([searchBar, addFriendsButton])

        searchBar.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.bottom.equalToSuperview()
        }

        addFriendsButton.snp.makeConstraints { make in
            make.leading.equalTo(searchBar.snp.trailing).offset(15).priority(.high)
            make.trailing.equalToSuperview().offset(-30).priority(.low)
            make.centerY.equalToSuperview()
        }
    }
}

extension FriendSearchView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.didChangeSearchText(searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        delegate?.searchBarDidBeginEditing()
    }
}
