//
//  CommentTableViewCell.swift
//  TheBoyage
//
//  Created by Madeline on 4/28/24.
//

import UIKit
import RxSwift
import SnapKit

class CommentTableViewCell: BaseTableViewCell {
    
    let disposeBag = DisposeBag()
    
    let profileView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "person.fill")
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 15
        return view
    }()
    
    let userNmaeLabel = {
        let view = UILabel()
        view.text = "트래블러 님"
        view.font = .systemFont(ofSize: 18, weight: .semibold)
        view.textColor = .point
        return view
    }()
    
    let createdAtLabel = {
        let view = UILabel()
        view.text = "2024.03.08"
        view.font = .systemFont(ofSize: 13, weight: .regular)
        view.textColor = .gray
        return view
    }()
    
    let contentLabel = {
        let view = UILabel()
        view.text = "content"
        view.font = .systemFont(ofSize: 14, weight: .medium)
        view.textColor = .point
        view.numberOfLines = 0
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        
    }
    
    private func configureView() {
        
        contentView.addSubview(profileView)
        contentView.addSubview(userNmaeLabel)
        contentView.addSubview(createdAtLabel)
        contentView.addSubview(contentLabel)
        
        profileView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(30)
        }
        
        userNmaeLabel.snp.makeConstraints { make in make.top.equalToSuperview().inset(20)
            make.leading.equalTo(profileView.snp.trailing).offset(8)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(profileView.snp.bottom).offset(8)
        }
        
        createdAtLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
        }
        
        contentLabel.numberOfLines = 0
        
    }
    
    func configure(with comment: CommentModel) {
        contentLabel.text = comment.content
        userNmaeLabel.text = comment.creator.nick
        let date = FormatterManager.shared.formatDateType(comment.createdAt)
        createdAtLabel.text = date
        loadProfileImage(imageName: comment.creator.profileImage)
    }
    
    private func loadProfileImage(imageName: String?) {
        ImageService.shared.loadImage(from: imageName)
            .subscribe(onNext: { [weak self] image in
                self?.profileView.image = image
            }, onError: { error in
                print("Failed to load image: \(error)")
                self.profileView.image = UIImage(systemName: "person.fill")
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
