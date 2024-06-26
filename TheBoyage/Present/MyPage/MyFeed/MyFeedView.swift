//
//  MyFeedView.swift
//  TheBoyage
//
//  Created by Madeline on 4/21/24.
//

import Foundation
import SnapKit
import UIKit

class MyFeedView: BaseView, UICollectionViewDataSource {
    
    let collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let viewModel = MyPageViewModel()
    
    override func configureView() {
        addSubview(collectionView)
        
        collectionView.register(MyFeedImageCollectionViewCell.self, forCellWithReuseIdentifier: MyFeedImageCollectionViewCell.identifier)
        collectionView.dataSource = self
    }
    
    override func configureHierarchy() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .vertical
        
        return layout
    }
}

extension MyFeedView {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyFeedImageCollectionViewCell.identifier, for: indexPath) as? MyFeedImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.imageView.image = UIImage(named: "shark")
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 15
        return cell
    }
}

class MyFeedImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "MyFeedImageCollectionViewCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func setupLayout() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
