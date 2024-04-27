//
//  BMainView.swift
//  TheBoyage
//
//  Created by Madeline on 4/27/24.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

class BMainView: BaseView {
    
    var disposeBag = DisposeBag()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    var viewModel: BMainViewModel!

    override func configureView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.register(MagazineCollectionViewCell.self, forCellWithReuseIdentifier: MagazineCollectionViewCell.identifier)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "TextCell")
        
    }
}
