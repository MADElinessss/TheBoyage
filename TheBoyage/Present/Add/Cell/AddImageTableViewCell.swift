//
//  AddImageTableViewCell.swift
//  TheBoyage
//
//  Created by Madeline on 4/15/24.
//

import SnapKit
import UIKit

final class AddImageTableViewCell: BaseTableViewCell {
    
//    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    let selectedImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "photo")
        view.tintColor = .lightGray
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 15
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        
    }
    
//    private func createLayout() -> UICollectionViewLayout {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(350))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(350))
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.interGroupSpacing = 5
//        
//        let layout = UICollectionViewCompositionalLayout(section: section)
//        
//        let configuration = UICollectionViewCompositionalLayoutConfiguration()
//        configuration.interSectionSpacing = 20
//        
//        layout.configuration = configuration
//        
//        return layout
//    }
//    
    private func configureView() {
        
        addSubview(selectedImageView)
        
        selectedImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalTo(100)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
