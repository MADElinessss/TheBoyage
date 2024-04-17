//
//  MagazineTableViewCell.swift
//  TheBoyage
//
//  Created by Madeline on 4/17/24.
//

import CollectionViewPagingLayout
import UIKit

class MagazineView: BaseView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    static var identifier: String {
        return String(describing: self)
    }

    var collectionView: UICollectionView!

    override func configureView() {
    
        let layout = CollectionViewPagingLayout()
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.register(MagazineCollectionViewCell.self, forCellWithReuseIdentifier: MagazineCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        addSubview(collectionView)
    }
    
    override func configureHierarchy() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension MagazineView {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MagazineCollectionViewCell.identifier, for: indexPath) as! MagazineCollectionViewCell
        
        
        return cell
    }
}
