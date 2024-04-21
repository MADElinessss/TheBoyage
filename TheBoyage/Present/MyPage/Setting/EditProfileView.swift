//
//  EditProfileView.swift
//  TheBoyage
//
//  Created by Madeline on 4/21/24.
//

import UIKit

class EditProfileView: BaseView {
    
    let tableView = UITableView()
    
    let updateButton = {
        let view = UIButton()
        view.setTitle("저장하기", for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        view.backgroundColor = .point
        view.tintColor = .white
        return view
    }()
    
    let withdrawButton = {
        let view = UIButton()
        view.setTitle("회원 탈퇴하기", for: .normal)
        view.backgroundColor = .clear
        view.setTitleColor(.lightGray, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        return view
    }()
    
    override func configureView() {
        addSubview(tableView)
        addSubview(updateButton)
        addSubview(withdrawButton)
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .point
        tableView.separatorInset = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        tableView.isScrollEnabled = false
    }
    
    override func configureHierarchy() {
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height * 0.6)
        }
        updateButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(54)
        }
        withdrawButton.snp.makeConstraints { make in
            make.top.equalTo(updateButton.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
        }
    }
}

class ProfileImageCell: BaseTableViewCell {
    
    let profileImageView = UIImageView()
    
    func configure() {
        
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = .lightGray
        
        contentView.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
    }
    
    func setImage(_ image: UIImage) {
        profileImageView.image = image
    }
}

class EditableTextCell: BaseTableViewCell {
    let titleLabel = UILabel()
    let textField = UITextField()

    func configure(placeholder: String) {
        textField.placeholder = placeholder
        titleLabel.text = placeholder
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(100)
            make.centerY.equalToSuperview()
        }
    }
}

class DatePickerCell: BaseTableViewCell {
    let titleLabel = UILabel()
    let datePicker = UIDatePicker()
    func configure() {
        titleLabel.text = "생년월일"
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .automatic
        
        contentView.addSubview(datePicker)
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        datePicker.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
}

