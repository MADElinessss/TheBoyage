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
    // TODO: Scrollview로 리팩토링
    let mainView = MainView()
    let viewModel = MainViewModel()
    
    var feed: [Posts] = []
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureNavigation()
        configureTableView()
    }
    
    override func bind() {
        let input = MainViewModel.Input()
        let output = viewModel.transform(input)
        
        output.posts
            .map { $0.data }
            .subscribe(onNext: { [weak self] posts in
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
        
        output.requireLogin
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.showLoginScreen()
            })
            .disposed(by: disposeBag)
        
//        output.feed
//            .map { $0.data }
//            .bind(to: mainView.feed.collectionView.rx.items(cellIdentifier: ImageCollectionViewCell.identifier, cellType: ImageCollectionViewCell.self)) {row, element, cell in
//                cell.topUserNameLabel.text = element.title
//            }
//            .disposed(by: disposeBag)
//        
//        output.requireLogin
//            .filter { $0 }
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] _ in
//                self?.showLoginScreen()
//            })
//            .disposed(by: disposeBag)
        
    }
    
    private func dummyPosts() -> [FetchModel] {
        return [FetchModel(data: [Posts(post_id: "1", createdAt: "1", creator: Creator(user_id: "", nick: ""), files: [], likes: [], likes2: [], hashTags: [], comments: [])])]
    }
    
    private func configureView() {

    }
    
    private func configureTableView() {
        
    }
    
    private func showLoginScreen() {
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

//extension MainViewController {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return feed.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//        let post = feed[indexPath.row]
//        cell.configure(with: FeedViewModel(), post: post)
//        cell.backgroundColor = .yellow
//        return cell
//    }
//}
