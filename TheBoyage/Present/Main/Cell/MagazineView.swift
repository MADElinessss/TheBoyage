//
//  MagazineTableViewCell.swift
//  TheBoyage
//
//  Created by Madeline on 4/17/24.
//

import CollectionViewPagingLayout
import UIKit
import RxSwift

class MagazineView: BaseView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    static var identifier: String {
        return String(describing: self)
    }

    var collectionView: UICollectionView!
    
    var viewModel = MainViewModel()
    
    var posts: [Posts] = []
    
    var disposeBag = DisposeBag()

    override func configureView() {
    
        let layout = CollectionViewPagingLayout()
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.register(MagazineCollectionViewCell.self, forCellWithReuseIdentifier: MagazineCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        addSubview(collectionView)
        
        bind()
    }
    
    private func bind() {
        let input = MainViewModel.Input()
        let output = viewModel.transform(input)
        output.posts
            .map { $0.data }
            .subscribe(with: self) { owner, posts in
                self.posts = posts
                print(posts)
                self.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension MagazineView {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MagazineCollectionViewCell.identifier, for: indexPath) as! MagazineCollectionViewCell
        cell.backgroundColor = .orange
        let post = posts[indexPath.row]
        cell.configure(with: MagazineCellViewModel(), post: post)
        return cell
    }
}
