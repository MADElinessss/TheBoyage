//
//  HashTagCollectionViewCell.swift
//  TheBoyage
//
//  Created by Madeline on 4/29/24.
//

import UIKit

class HashTagCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    let hashTagLabel = {
        let view = UILabel()
        view.text = "맛집"
        view.font = .systemFont(ofSize: 16, weight: .bold)
        view.textColor = .point
        view.numberOfLines = 1
        return view
    }()
    
    func configure(with tag: String) {
        hashTagLabel.text = tag
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    func configureView() {
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.addSubview(hashTagLabel)
        
        hashTagLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
