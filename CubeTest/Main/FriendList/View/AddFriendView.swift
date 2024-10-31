//
//  AddFriendView.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//
import UIKit
import SnapKit

class AddFriendView: UIView {
    private let illustrationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(asset: .iconAddFriendIllustration)
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "就從加好友開始吧：)"
        label.apply(font: UIFont.font(.pingFangMedium, fontSize: 21), textColor: .greyishBrown, textAlignment: .center)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "與好友們一起用 KOKO 聊起來！\n還能互相收付款、發紅包唷：)"
        label.apply(font: UIFont.font(.pingFangRegular, fontSize: 14), textColor: .lightGrey, textAlignment: .center, numberOfLines: 0)
        return label
    }()
    
    private let addFriendButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private lazy var addFriendButtonView: UIView = {
        let view = setupAddFriendButtonView()
        return view
    }()
    
    private let helpContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    private let helpLabel: UILabel = {
        let label = UILabel()
        label.text = "幫助好友更快找到你？"
        label.apply(font: UIFont.font(.pingFangRegular, fontSize: 14), textColor: .lightGrey, textAlignment: .center)
        return label
    }()
    
    private let setIdButton: UIButton = {
        let button = UIButton()
        let text = "設定 KOKO ID"
        let attributedString = text.attributed(fontType: .pingFangRegular, size: 13, color: .hotPink)
        attributedString.setUnderLineForText(text, with: .single)
        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addFriendButtonView.layer.cornerRadius = addFriendButtonView.frame.height / 2
    }
}

private extension AddFriendView {
    func setupConstraints() {
        backgroundColor = .white
        
        addSubviews([illustrationImageView, titleLabel, descriptionLabel, addFriendButtonView, helpContainer])
        helpContainer.addArrangeSubviews([helpLabel, setIdButton])
        
        // Setup constraints
        illustrationImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(illustrationImageView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(44)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }
        
        addFriendButtonView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
        }
        
        helpContainer.snp.makeConstraints { make in
            make.top.equalTo(addFriendButtonView.snp.bottom).offset(37)
            make.centerX.equalToSuperview()
        }
    }
    
    func setupAddFriendButtonView() -> UIView{
        let containerView = UIView()
        containerView.backgroundColor = .frogGreen
        
        let addFirendLabel = UILabel()
        addFirendLabel.apply(font: UIFont.font(.pingFangMedium, fontSize: 16), textColor: .white)
        addFirendLabel.text = "加好友"
        
        let addFriendImageView = UIImageView()
        addFriendImageView.image = UIImage(asset: .iconAddFriendButton)
        
        containerView.addSubviews([addFirendLabel, addFriendImageView, addFriendButton])
        addFirendLabel.snp.makeConstraints({
            $0.top.bottom.equalToSuperview().inset(9)
            $0.left.right.equalToSuperview().inset(48)
        })
        addFriendImageView.snp.makeConstraints({
            $0.right.equalToSuperview().offset(-8)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        })
        addFriendButton.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        return containerView
    }
    
}

extension AddFriendView {
    func show(targetView: UIView) {
        if superview == nil {
            targetView.addSubview(self)
            targetView.bringSubviewToFront(self)
            snp.remakeConstraints({ make in
                make.top.bottom.trailing.leading.equalToSuperview()
                make.width.equalTo(targetView.snp.width)
                make.height.equalTo(targetView.snp.height)
            })
        }
    }

    func remove() {
        DispatchQueue.main.async {
            if self.superview != nil {
                self.removeFromSuperview()
            }
        }
    }
}

