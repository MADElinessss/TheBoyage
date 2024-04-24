//
//  EmptyCollectionViewCell.swift
//  TheBoyage
//
//  Created by Madeline on 4/25/24.
//

import Foundation
import UIKit


class EmptyCollectionViewCell: UICollectionViewCell {
    static let identifier = "EmptyCollectionViewCell"
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 여행기가 없어요. 당신의 이야기를 들려주세요!"
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
}
