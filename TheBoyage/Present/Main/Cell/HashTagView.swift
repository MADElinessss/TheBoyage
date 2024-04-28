//
//  HashTagView.swift
//  TheBoyage
//
//  Created by Madeline on 4/29/24.
//

import UIKit
import SnapKit
import RxSwift

class HashTagView: BaseView {
    
    var disposeBag = DisposeBag()
    var tags = ["유럽여행", "국내여행", "맛집", "혼자여행", "가족과 함께", "강아지와 함께"]
    
    let collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.showsHorizontalScrollIndicator = true
        return collectionView
    }()
    
    override func configureView() {
        addSubview(collectionView)
        
        collectionView.register(HashTagCollectionViewCell.self, forCellWithReuseIdentifier: HashTagCollectionViewCell.identifier)
        
        bindCollectionView()
    }
    
    func bindCollectionView() {
        Observable.just(tags)
            .bind(to: collectionView.rx.items(cellIdentifier: HashTagCollectionViewCell.identifier, cellType: HashTagCollectionViewCell.self)) { index, tag, cell in
                cell.configure(with: tag)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }

    static func layout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 100, height: 44)
        // layout.itemSize = CGSize(width: .min, height: 44)
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
        layout.scrollDirection = .horizontal
        
        return layout
    }
}
