//
//  FeedView.swift
//  TheBoyage
//
//  Created by Madeline on 4/17/24.
//

import UIKit
import RxSwift

class FeedView: BaseView, UICollectionViewDataSource {

    var viewModel = MainViewModel()
    
    var feed: [Posts] = []
    
    var disposeBag = DisposeBag()
    
    let collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override func configureView() {
        addSubview(collectionView)
        
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        let post = feed[indexPath.row]
        cell.configure(with: FeedViewModel(), post: post)
        
        return cell
    }

    override func configureHierarchy() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 350, height: 450)
        layout.scrollDirection = .horizontal
        return layout
    }

}

class ImageCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    var viewModel: FeedViewModel?
    private var disposeBag = DisposeBag()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        configureView()
    }
    
    func configure(with viewModel: FeedViewModel, post: Posts) {
        self.viewModel = viewModel
        bind(post: post)
    }
    
    private func bind(post: Posts) {
        let input = FeedViewModel.Input(post: post)
        guard let output = viewModel?.transform(input) else { return }
        
        output.image
            .asDriver(onErrorJustReturn: UIImage(systemName: "airplane.departure")!)
            .drive(imageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    private func configureView() {
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
