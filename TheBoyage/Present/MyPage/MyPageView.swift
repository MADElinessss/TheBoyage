//
//  MyPageView.swift
//  TheBoyage
//
//  Created by Madeline on 4/15/24.
//

import SnapKit
import UIKit

class MyPageView: BaseView {
    
    let collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.showsHorizontalScrollIndicator = true
        return collectionView
    }()
    
    let contentView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profile = ProfileCollectionViewCell()
    let myFeed = MyFeedView()
    
    override func configureView() {

        addSubview(collectionView)
    }
    
    override func configureHierarchy() {
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    static func layout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        
        let width = (UIScreen.main.bounds.width * 0.9)
        let height = (UIScreen.main.bounds.height * 0.9)
        layout.itemSize = CGSize(width: width, height:height)
        layout.minimumLineSpacing = 8
//        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
        layout.scrollDirection = .vertical
        
        return layout
    }
}
