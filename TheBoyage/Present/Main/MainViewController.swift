//
//  MainViewController.swift
//  TheBoyage
//
//  Created by Madeline on 4/13/24.
//

import UIKit
import SnapKit
import RxSwift

class MainViewController: BaseViewController {
    
    let mainView = MainView()
    let viewModel = MainViewModel()
    
    var magazine: [Posts] = []
    var feed: [Posts] = []
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureNavigation()
    }
    
    override func bind() {
        let input = MainViewModel.Input()
        let output = viewModel.transform(input)
        
        output.posts
            .map { $0.data }
            .subscribe(onNext: { [weak self] posts in
                self?.magazine = posts
                self?.mainView.magazine.posts = posts
                self?.mainView.magazine.collectionView.reloadData()
            }, onError: { [weak self] error in
                guard let self = self, let urlError = error as? URLError, urlError.code == .cancelled else { return }
                self.showLoginNeededAlert()
            })
            .disposed(by: disposeBag)
        
        output.feed
            .map { $0.data }
            .subscribe(onNext: { [unowned self] posts in
                self.mainView.feed.collectionView.reloadData()
            }, onError: { error in
                guard let urlError = error as? URLError, urlError.code == .cancelled else { return }
                self.showLoginNeededAlert()
            })
            .disposed(by: disposeBag)
        
        output.feed
            .map { $0.data }
            .do(onNext: { [weak self] posts in
                self?.feed = posts // feed 배열을 갱신
                self?.mainView.feed.collectionView.reloadData()
            })
            .bind(to: mainView.feed.collectionView.rx.items(cellIdentifier: ImageCollectionViewCell.identifier, cellType: ImageCollectionViewCell.self)) { row, element, cell in
                let viewModel = FeedViewModel()
                cell.configure(with: viewModel, post: element)
            }
            .disposed(by: disposeBag)
        
        output.requireLogin
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                print("---------mainVC require login-----------")
                self?.showLoginScreen()
                print("---------mainVC showLoginScreen-----------")
            })
            .disposed(by: disposeBag)
        
        // TODO: Mainview -> CollectionView로 리팩토링 후 .modelSelected -> Detail로 연결
        mainView.feed.collectionView.rx.modelSelected(Posts.self)
            .subscribe(onNext: { [weak self] post in
                guard let self = self else { return }
                let detailVC = DetailPostViewController()
                detailVC.post = post
                self.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.magazine.collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                if indexPath.section == 0 {
                    let post = self.magazine[indexPath.row]
                    let detailVC = DetailPostViewController()
                    detailVC.post = post
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
    }

    private func configureView() {
    }
    
    private func showLoginScreen() {
        print("---------showLoginScreen-----------")
        let signInVC = SignInViewController()
        signInVC.modalPresentationStyle = .fullScreen
        present(signInVC, animated: true, completion: nil)
    }
    
    private func configureNavigation() {
        let title = "B O Y A G E"
        navigationController?.title = title
        
        let leftButton = createBarButtonItem(imageName: "bell", action: #selector(leftBarButtonTapped))
        let rightButton = createBarButtonItem(imageName: "magnifyingglass", action: #selector(rightBarButtonTapped))
        configureNavigationBar(title: title, leftBarButton: leftButton, rightBarButton: rightButton)
    }
    
    @objc func leftBarButtonTapped() {
        
    }
    
    @objc func rightBarButtonTapped() {
        
    }
    
    private func showLoginNeededAlert() {
        AlertManager.shared.showOkayAlert(
            on: self,
            title: "로그인 후 다시 시도해주세요.",
            message: "데이터를 불러올 수 없습니다. 로그인 화면으로 이동할까요?",
            completion: { [weak self] in
                self?.navigateToSignIn()
            }
        )
    }

    private func navigateToSignIn() {
        let signInVC = SignInViewController()
        let navController = UINavigationController(rootViewController: signInVC)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
}
