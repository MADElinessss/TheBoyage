//
//  DetailPostViewController.swift
//  TheBoyage
//
//  Created by Madeline on 4/25/24.
//

import RxCocoa
import RxSwift
import UIKit

class DetailPostViewController: BaseViewController {
    
    let mainView = DetailPostView()
    var post: Posts?
    let viewModel = DetailViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        mainView.collectionView.dataSource = nil

        bind()
    }
    
    override func bind() {
        guard let post = post else { return }

        mainView.collectionView.visibleCells.forEach {
            if let cell = $0 as? DetailPostCollectionViewCell {
                cell.bind(post: post)
            }
        }
        
        Observable.just([post])
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: DetailPostCollectionViewCell.identifier, cellType: DetailPostCollectionViewCell.self)) { row, post, cell in
                cell.bind(post: post)
            }
            .disposed(by: disposeBag)
        
        Observable.just(post)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] post in
                self?.mainView.bind(post: post)
            })
            .disposed(by: disposeBag)
        
        mainView.commentButtonTap
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    self.showCommentViewController()
                })
                .disposed(by: disposeBag)
    }
    
    private func showCommentViewController() {
        guard let post = post else { return }
        let commentVC = CommentViewController()
        commentVC.comments = post.comments
        navigationController?.pushViewController(commentVC, animated: true)
    }

    func configureView() {
        configureNavigation()
        mainView.collectionView.register(DetailPostCollectionViewCell.self, forCellWithReuseIdentifier: DetailPostCollectionViewCell.identifier)
            
    }
    
    private func configureNavigation() {
        configureNavigationBar(title: "Travel Feed", leftBarButton: nil, rightBarButton: nil)
    }
}
