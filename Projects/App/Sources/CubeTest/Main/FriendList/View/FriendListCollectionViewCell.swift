//
//  FriendListCollectionViewCell.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//
import UIKit
import SnapKit

struct FriendListCollectionViewData: Hashable {
    static func == (lhs: FriendListCollectionViewData, rhs: FriendListCollectionViewData) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    let uuid = UUID().uuidString

    let model: FriendListResponse
}

class FriendListCollectionViewCell: UICollectionViewCell, ConfigUI {
    typealias ViewData = FriendListCollectionViewData
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(asset: .iconFriendStar)
        return imageView
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
    
    private let statusButtonContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private lazy var transferButton: UIButton = {
        let button = createButton(title: "轉帳", titleColorHex: "#ec008c", borderColorHex: "#ec008c")
        return button
    }()
    
    private lazy var inviteButton: UIButton = {
        let button = createButton(title: "邀請中", titleColorHex: "#999999", borderColorHex: "#c9c9c9")
        return button
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    private let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteThree
        return view
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        statusButtonContainer.removeArrangeSubviews()
    }
    
    func configure(viewData: FriendListCollectionViewData) {
        let model = viewData.model
        starImageView.isHidden = !model.isTop
        avatarImageView.image = UIImage(asset: .iconDefaultAvatar)
        nameLabel.text = model.name
       
        switch model.status {
        case .invitationSent:
            break
        case .completed:
            statusButtonContainer.spacing = 25
            statusButtonContainer.addArrangeSubviews([transferButton, moreButton])
        case .inviting:
            statusButtonContainer.spacing = 10
            statusButtonContainer.addArrangeSubviews([transferButton, inviteButton])
        }
    }
  
}

private extension FriendListCollectionViewCell {
    func setupConstraints() {
        contentView.addSubviews([starImageView, avatarImageView, nameLabel, statusButtonContainer, bottomLineView])
        starImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(14)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(15)
            make.top.bottom.equalToSuperview().inset(20)
        }
        
        statusButtonContainer.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
        
        bottomLineView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.left.equalTo(nameLabel.snp.left)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
    
    func createButton(title: String, titleColorHex: String, borderColorHex: String) -> UIButton {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(hex: titleColorHex), for: .normal)
        button.backgroundColor = .white
        
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 1.2
        button.layer.borderColor = UIColor(hex: borderColorHex).cgColor
        button.titleLabel?.font = UIFont.font(.pingFangMedium, fontSize: 14)
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)
        button.configuration = configuration
        
        return button
    }
}
