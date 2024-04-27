//
//  DetailPostCollectionViewCell.swift
//  TheBoyage
//
//  Created by Madeline on 4/25/24.
//

import Kingfisher
import SnapKit
import UIKit
import RxSwift

class DetailPostCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    let toolbar = UIView()
    
    let profileView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    let topUserNameLabel = {
        let view = UILabel()
        view.text = "user"
        view.font = .systemFont(ofSize: 15, weight: .medium)
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
    
    let menuButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        view.tintColor = .point
        return view
    }()
    
    let feedImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo.artframe")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let likeButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "heart"), for: .normal)
        view.tintColor = .point
        return view
    }()
    
    let commentButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        view.tintColor = .point
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.text = "title"
        view.font = .systemFont(ofSize: 18, weight: .bold)
        view.textColor = .point
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
    
    var viewModel: FeedViewModel?
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        feedImageView.image = nil
        disposeBag = DisposeBag()
    }
    
    func bind(post: Posts) {
        titleLabel.text = post.title
        
        updateContentLabel(text: post.content ?? "")
        contentLabel.text = post.content
        
        if let imageURL = URL(string: post.files.first ?? "") {
            feedImageView.kf.setImage(with: imageURL)
        }
        
        // 유저 정보 설정
        topUserNameLabel.text = post.creator.nick
        let date = FormatterManager.shared.formatDateType(post.createdAt)
        createdAtLabel.text = date
        
        
    }
    
    func updateContentLabel(text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8

        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: text.count))

        contentLabel.attributedText = attributedString
    }

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
   
    private func configureView() {
        contentView.addSubview(profileView)
        contentView.addSubview(topUserNameLabel)
        contentView.addSubview(createdAtLabel)
        contentView.addSubview(feedImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(menuButton)

        feedImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(16)
        }
        
        profileView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(40)
        }
        
        topUserNameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(profileView.snp.trailing).offset(8)
        }
        
        createdAtLabel.snp.makeConstraints { make in
            make.top.equalTo(topUserNameLabel.snp.bottom).offset(4)
            make.leading.equalTo(profileView.snp.trailing).offset(8)
        }
        
        menuButton.snp.makeConstraints { make in
            make.top.equalTo(topUserNameLabel.snp.top)
            make.trailing.equalToSuperview().inset(24)
        }
        
        feedImageView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.width.equalTo(165)
            make.height.equalTo(300)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(feedImageView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    private func configureMenuButton(currentUserId: String, postOwnerId: String) {
        let isMyPost = (currentUserId == postOwnerId)
        
        let saveAction = UIAction(title: "저장") { action in
            // 저장 로직
            
        }
        
        var actions: [UIAction] = [saveAction]
        
        if isMyPost {
            let editAction = UIAction(title: "수정") { action in
                // 수정 로직
            }
            let deleteAction = UIAction(title: "삭제", attributes: .destructive) { action in
                // 삭제 로직
            }
            actions.append(contentsOf: [editAction, deleteAction])
        }
        
        menuButton.menu = UIMenu(title: "편집", children: actions)
        menuButton.showsMenuAsPrimaryAction = true
    }
    
}
