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
        imageView.backgroundColor = .red
        return imageView
    }()
    
    let topUserNameLabel = {
        let view = UILabel()
        view.text = "user"
        view.font = .systemFont(ofSize: 16, weight: .medium)
        view.textColor = .point
        view.backgroundColor = .red
        return view
    }()
    
    let feedImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .red
        return imageView
    }()
    
    let likeButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "heart"), for: .normal)
        view.tintColor = .point
        view.backgroundColor = .red
        return view
    }()
    
    let commentButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        view.tintColor = .point
        view.backgroundColor = .red
        return view
    }()
    
    let bottomUserNameLabel = {
        let view = UILabel()
        view.text = "user"
        view.font = .systemFont(ofSize: 16, weight: .medium)
        view.textColor = .point
        view.backgroundColor = .red
        return view
    }()
    
    let contentLabel = {
        let view = UILabel()
        view.text = "content"
        view.font = .systemFont(ofSize: 16, weight: .medium)
        view.textColor = .point
        view.backgroundColor = .red
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
        bind(post: post)
    }
    
    private func bind(post: Posts) {
        let input = FeedViewModel.Input(post: post)
        
        print("input = ", post)
        guard let output = viewModel?.transform(input) else { return }
        
        output.feedImage
            .asDriver(onErrorJustReturn: UIImage(systemName: "airplane.departure")!)
            .drive(feedImageView.rx.image)
            .disposed(by: disposeBag)
        
        output.profileImage
            .asDriver(onErrorJustReturn: UIImage(systemName: "person.fill")!)
            .drive(profileView.rx.image)
            .disposed(by: disposeBag)
        
        topUserNameLabel.text = post.creator.nick
        bottomUserNameLabel.text = post.creator.nick
        contentLabel.text = post.content
        
    }
    
    private func configureView() {
        contentView.backgroundColor = .red
        contentView.addSubview(profileView)
        contentView.addSubview(topUserNameLabel)
        contentView.addSubview(feedImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(bottomUserNameLabel)
        contentView.addSubview(contentLabel)
        
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
        
        feedImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(profileView.snp.bottom).offset(16)
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
        
        bottomUserNameLabel.snp.makeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom).offset(16)
            make.leading.equalTo(likeButton.snp.trailing).offset(8)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(bottomUserNameLabel.snp.trailing).offset(16)
            make.top.equalTo(likeButton.snp.bottom).offset(16)
        }
    }
}
