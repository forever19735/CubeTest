//
//  UserInfoView.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//

import UIKit
import SnapKit

struct UserInfoViewData {
    let name: String?
    let id: String?
}

class UserInfoView: UIView, ConfigUI {
    typealias ViewData = UserInfoViewData
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.apply(font: UIFont.font(.pingFangMedium, fontSize: 17), textColor: .greyishBrown)
        return label
    }()
    
    private let idButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(asset: .iconRightArrow), for: .normal)
        button.titleLabel?.font = UIFont.font(.pingFangRegular, fontSize: 13)
        button.setTitleColor( .greyishBrown, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft

        return button
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(asset: .iconDefaultAvatar)
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .whiteTwo
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension UserInfoView {
    func configure(viewData: UserInfoViewData) {
        nameLabel.text = viewData.name
        idButton.setTitle(viewData.id, for: .normal)
    }
}

private extension UserInfoView {
    func setupConstraints() {
        addSubviews([nameLabel, idButton, avatarImageView])
        nameLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(16)
            $0.left.equalToSuperview().offset(30)
        })
        idButton.snp.makeConstraints({
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.left.equalTo(nameLabel)
            $0.bottom.equalToSuperview().offset(-10)
        })
        avatarImageView.snp.makeConstraints({
            $0.right.equalTo(-30)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(54)
        })
    }
}
