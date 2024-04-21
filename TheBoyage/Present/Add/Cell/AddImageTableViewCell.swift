//
//  AddImageTableViewCell.swift
//  TheBoyage
//
//  Created by Madeline on 4/15/24.
//

import SnapKit
import RxSwift
import UIKit

final class AddImageTableViewCell: BaseTableViewCell {
    
    let disposeBag = DisposeBag()
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
    
    func configure(with imagesObservable: Observable<[UIImage]>) {
        imagesObservable
            .subscribe(onNext: { [weak self] images in
                self?.selectedImageView.image = images.first // 예시로 첫 번째 이미지만 표시
            })
            .disposed(by: disposeBag)
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
