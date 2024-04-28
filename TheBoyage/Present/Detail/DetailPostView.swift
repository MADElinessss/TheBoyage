//
//  DetailPostView.swift
//  TheBoyage
//
//  Created by Madeline on 4/25/24.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class DetailPostView: BaseView, UITextFieldDelegate {

    var disposeBag = DisposeBag()
    
    let collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.showsHorizontalScrollIndicator = true
        return collectionView
    }()
    
    let toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        return toolbar
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .point
        return button
    }()
    
    let likeCount: UILabel = {
        let view = UILabel()
        view.text = "0"
        view.font = .systemFont(ofSize: 13, weight: .medium)
        view.textColor = .point
        return view
    }()
    
    let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        button.tintColor = .point
        return button
    }()
    
    let commentCount: UILabel = {
        let view = UILabel()
        view.text = "0"
        view.font = .systemFont(ofSize: 13, weight: .medium)
        view.textColor = .point
        return view
    }()
    
    let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .point
        return button
    }()
    
    let viewModel = DetailViewModel()
    var commentButtonTap = PublishSubject<Void>()
    
    override func configureView() {
        
        addSubview(collectionView)
        addSubview(toolbar)
        
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
    
        // MARK: ToolBar Related
        let likeItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(likeButtonTapped))
        let commentItem = UIBarButtonItem(image: UIImage(systemName: "bubble.left"), style: .plain, target: self, action: #selector(commentButtonTapped))
        let shareItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonTapped))

        let likeCountItem = UIBarButtonItem(customView: likeCount)
        let commentCountItem = UIBarButtonItem(customView: commentCount)
        
        let paddingItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        paddingItem.width = 8
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([likeItem, likeCountItem, paddingItem, commentItem, commentCountItem, flexSpace, flexSpace, shareItem], animated: false)
    }
    
    @objc private func commentButtonTapped() {
        commentButtonTap.onNext(())
    }
    
    func bind(post: Posts) {
        likeCount.text = "\(post.likes.count)"
        commentCount.text = "\(post.comments.count)"
    }
    
    @objc private func likeButtonTapped() {
        likeButton.isSelected.toggle()
        let imageName = likeButton.isSelected ? "heart.fill" : "heart"
        likeButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func shareButtonTapped() {
        // TODO: 공유 기능
    }
    
    override func configureHierarchy() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        toolbar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }
    
    static func layout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        
        let width = (UIScreen.main.bounds.width - 36)
        layout.itemSize = CGSize(width: width, height: width*1.5)
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
        layout.scrollDirection = .vertical
        
        return layout
    }

}
