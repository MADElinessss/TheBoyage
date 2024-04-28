//
//  DetailPostViewController.swift
//  TheBoyage
//
//  Created by Madeline on 4/25/24.
//

import RxCocoa
import RxSwift
import UIKit

class DetailPostViewController: UIViewController {
    
    let mainView = DetailPostView()
    var post: Posts?
    let viewModel = DetailViewModel()
    var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    // MARK: TabBar 숨기기
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
        view.backgroundColor = .white
        configureView()
        mainView.collectionView.dataSource = nil
        bind()
    }
    
    func bind() {
        // 화면 전환 2번될 때 <- 가방 재할당
        disposeBag = DisposeBag()
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
                guard let self = self, let post = self.post else { return }
                let commentVC = CommentViewController()
                commentVC.comments = post.comments
                self.navigationController?.pushViewController(commentVC, animated: true)
            })
            .disposed(by: disposeBag)
    }

    func configureView() {
        configureNavigation()
        mainView.collectionView.register(DetailPostCollectionViewCell.self, forCellWithReuseIdentifier: DetailPostCollectionViewCell.identifier)
    }
    
    private func configureNavigation() {
        self.navigationItem.title = "Travel Feed"
    }
}
