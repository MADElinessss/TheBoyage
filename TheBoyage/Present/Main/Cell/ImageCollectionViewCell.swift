//
//  ImageCollectionViewCell.swift
//  TheBoyage
//
//  Created by Madeline on 4/23/24.
//

import Kingfisher
import SnapKit
import UIKit
import RxSwift

class ImageCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    let profileView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .blue
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    let topUserNameLabel = {
        let view = UILabel()
        view.text = "user"
        view.font = .systemFont(ofSize: 16, weight: .medium)
        view.textColor = .point
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
        view.font = .systemFont(ofSize: 16, weight: .bold)
        view.textColor = .point
        return view
    }()
    
    let contentLabel = {
        let view = UILabel()
        view.text = "content"
        view.font = .systemFont(ofSize: 14, weight: .medium)
        view.textColor = .point
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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    func configure(with viewModel: FeedViewModel, post: Posts) {
        self.viewModel = viewModel
        let input = FeedViewModel.Input(post: post)
        let output = viewModel.transform(input)
        
        output.feedImage
            .asDriver(onErrorJustReturn: UIImage(systemName: "airplane.departure")!)
            .drive(feedImageView.rx.image)
            .disposed(by: disposeBag)
        
        output.profileImage
            .asDriver(onErrorJustReturn: UIImage(systemName: "person.fill")!)
            .drive(profileView.rx.image)
            .disposed(by: disposeBag)
        
        topUserNameLabel.text = post.creator.nick
        titleLabel.text = post.title
        contentLabel.text = post.content
        
        // TODO: 내 글이냐 아니냐 <- 닉네임으로 해야되나?
        configureMenuButton(currentUserId: "1", postOwnerId: "1")
    }
    
    private func configureView() {
        contentView.addSubview(profileView)
        contentView.addSubview(topUserNameLabel)
        contentView.addSubview(feedImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(menuButton)
        
        feedImageView.translatesAutoresizingMaskIntoConstraints = false
        
        profileView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(35)
            make.top.equalToSuperview().inset(16)
        }
        
        topUserNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileView.snp.trailing).offset(8)
            make.top.equalToSuperview().inset(24)
        }
        
        menuButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(24)
        }
        
        feedImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(profileView.snp.bottom).offset(16)
            make.size.equalTo(165)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(feedImageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(35)
        }
        
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(feedImageView.snp.bottom).offset(16)
            make.leading.equalTo(likeButton.snp.trailing).offset(8)
            make.size.equalTo(35)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(likeButton.snp.bottom).offset(16)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
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
