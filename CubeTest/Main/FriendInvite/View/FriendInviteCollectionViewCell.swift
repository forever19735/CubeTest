//
//  FriendInviteCollectionViewCell.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//
import UIKit
import SnapKit

struct FriendInviteCollectionViewData: Hashable {
    static func == (lhs: FriendInviteCollectionViewData, rhs: FriendInviteCollectionViewData) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    let uuid = UUID().uuidString

    let model: FriendListResponse
}

class FriendInviteCollectionViewCell: UICollectionViewCell, ConfigUI {
    typealias ViewData = FriendInviteCollectionViewData
        
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.pingFangRegular, fontSize: 16), textColor: .greyishBrown)
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.pingFangRegular, fontSize: 13), textColor: .lightGrey)
        label.text = "邀請你成為好友：)"
        return label
    }()
    
    private lazy var acceptButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(asset: .iconFriendsAccept), for: .normal)
        button.addTarget(self, action: #selector(acceptTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var declineButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(asset: .iconFriendsDecline), for: .normal)
        button.addTarget(self, action: #selector(declineTapped), for: .touchUpInside)
        return button
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func configure(viewData: FriendInviteCollectionViewData) {
        avatarImageView.image = UIImage(asset: .iconDefaultAvatar)
        nameLabel.text = viewData.model.name
    }
}

extension FriendInviteCollectionViewCell {
    @objc func acceptTapped() {
   
    }
    
    @objc func declineTapped() {
        
    }
}

private extension FriendInviteCollectionViewCell {
   func setupConstraints() {
        contentView.backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.addSubviews([avatarImageView, nameLabel, messageLabel, acceptButton, declineButton])

        // Setup constraints
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(15)
            make.top.equalToSuperview().offset(14)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.bottom.equalToSuperview().offset(-14)
        }
        
        declineButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.right.equalTo(declineButton.snp.left).offset(-15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
    }
}
