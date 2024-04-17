//
//  MagazineCollectionViewCell.swift
//  TheBoyage
//
//  Created by Madeline on 4/17/24.
//

import CollectionViewPagingLayout
import SnapKit
import UIKit

class MagazineCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    var card: UIView!
    let titleLabel = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure() {
        
        let cardFrame = CGRect(
            x: 50,
            y: 50,
            width: frame.width*0.8,
            height: frame.height*0.8
        )
        card = UIView(frame: cardFrame)
        card.backgroundColor = .point
        card.layer.cornerRadius = 20
        
        contentView.addSubview(card)
        card.addSubview(titleLabel)
        card.addSubview(imageView)
        
        titleLabel.text = "오늘의 행운은?"
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .white
        imageView.image = UIImage(named: "shark")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(card)
            make.top.equalTo(card).inset(44)
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(card)
        }
    }
}

extension MagazineCollectionViewCell: ScaleTransformView {
    var scaleOptions: ScaleTransformViewOptions {
        .layout(.linear)
    }
}
