//
//  MagazineCollectionViewCell.swift
//  TheBoyage
//
//  Created by Madeline on 4/17/24.
//

import CollectionViewPagingLayout
import Kingfisher
import SnapKit
import UIKit
import RxSwift

class MagazineCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    var card: UIView!
    let titleLabel = UILabel()
    let imageView = UIImageView()
    var viewModel: MagazineCellViewModel?
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    func configure(with viewModel: MagazineCellViewModel, post: Posts) {
        self.viewModel = viewModel
        bind(post: post)
    }
    
    private func bind(post: Posts) {
        let input = MagazineCellViewModel.Input(post: post)
        guard let output = viewModel?.transform(input) else { return }
        
        output.title
            .asDriver(onErrorJustReturn: "")
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.image
            .asDriver(onErrorJustReturn: UIImage(systemName: "airplane.departure")!)
            .drive(imageView.rx.image)
            .disposed(by: disposeBag)
    }

    func configureView() {
        
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
        card.addSubview(imageView)
        card.addSubview(titleLabel)
        
        titleLabel.text = "오늘의 행운은?"
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.shadowColor = .black
        titleLabel.shadowOffset = CGSize(width: 1, height: 1)
        imageView.image = UIImage(named: "shark")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(card)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(card)
            make.bottom.equalTo(card).inset(44)
        }
    }
}

extension MagazineCollectionViewCell: ScaleTransformView {
    var scaleOptions: ScaleTransformViewOptions {
        .layout(.linear)
    }
}
