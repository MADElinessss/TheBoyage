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
    
    override func configureView() {
        
        addSubview(collectionView)
        
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
    }
    
    override func configureHierarchy() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }

    static func layout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        
        let width = (UIScreen.main.bounds.width - 48)
        layout.itemSize = CGSize(width: width, height: width*1.5)
        layout.minimumLineSpacing = 8
//        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
        layout.scrollDirection = .vertical
        
        return layout
    }

}
