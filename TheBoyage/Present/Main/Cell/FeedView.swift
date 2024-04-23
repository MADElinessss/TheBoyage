//
//  FeedView.swift
//  TheBoyage
//
//  Created by Madeline on 4/17/24.
//

import UIKit
import SnapKit
import RxSwift

class FeedView: BaseView {
    
    var disposeBag = DisposeBag()
    
    let collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.showsHorizontalScrollIndicator = true
        return collectionView
    }()
    
    override func configureView() {
        
        addSubview(collectionView)
        
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        
        
        collectionView.backgroundColor = .lightGray
    }
    
    override func configureHierarchy() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }

    static func layout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        
        let width = (UIScreen.main.bounds.width - 48)
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 8
//        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
        layout.scrollDirection = .vertical
        
        
//        layout.itemSize = CGSize(width: 200, height: 300)
        return layout
    }

}
