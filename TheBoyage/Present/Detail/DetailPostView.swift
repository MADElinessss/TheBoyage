//
//  DetailPostView.swift
//  TheBoyage
//
//  Created by Madeline on 4/25/24.
//

import UIKit
import SnapKit
import RxSwift

class DetailPostView: BaseView {

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
    
    let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        button.tintColor = .point
        return button
    }()
    
    override func configureView() {
        
        addSubview(collectionView)
        addSubview(toolbar)
        
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        
        let likeItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(likeButtonTapped))
        let commentItem = UIBarButtonItem(image: UIImage(systemName: "bubble.left"), style: .plain, target: self, action: #selector(commentButtonTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexSpace, likeItem, flexSpace, commentItem, flexSpace], animated: false)
        
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
    }
    
    @objc private func likeButtonTapped() {
        // Like button action
    }

    @objc private func commentButtonTapped() {
        // Comment button action
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
