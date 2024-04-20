//
//  AddImageTableViewCell.swift
//  TheBoyage
//
//  Created by Madeline on 4/15/24.
//

import SnapKit
import UIKit

final class AddImageTableViewCell: BaseTableViewCell {
    
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
