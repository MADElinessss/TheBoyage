//
//  ProfileView.swift
//  TheBoyage
//
//  Created by Madeline on 4/21/24.
//

import Foundation
import UIKit

class ProfileView: BaseView {
    let profileImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "person.fill")
        view.tintColor = .white
        view.backgroundColor = .lightGray
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.clipsToBounds = true
        view.layer.cornerRadius = 50
        return view
    }()
    
    let nameLabel = {
        let view = UILabel()
        view.text = "트래블러 님"
        view.font = .systemFont(ofSize: 18, weight: .semibold)
        view.textColor = .white
        return view
    }()
    
    let editButton = {
        let view = UIButton()
        view.setTitle("프로필 편집", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        view.setImage(UIImage(systemName: "pencil"), for: .normal)
        view.tintColor = .white
        return view
    }()
    
    override func configureView() {
        backgroundColor = .point
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(editButton)
    }
    
    override func configureHierarchy() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(44)
            make.leading.equalToSuperview().inset(24)
            make.size.equalTo(100)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(54)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
        }
        editButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
        }
    }
    
    func configure(profile: MyProfileModel) {
        nameLabel.text = profile.nick
    }
    
}
