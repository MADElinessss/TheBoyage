//
//  MyPageViewController.swift
//  TheBoyage
//
//  Created by Madeline on 4/13/24.
//

import UIKit
import RxSwift

class MyPageViewController: BaseViewController {

    let mainView = MyPageView()
    let viewModel = MyPageViewModel()
    private var feedImages = [UIImage]()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigation()
    }
    
    private func configureView() {
        mainView.collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        mainView.collectionView.register(MyFeedImageCollectionViewCell.self, forCellWithReuseIdentifier: MyFeedImageCollectionViewCell.identifier)
        mainView.collectionView.register(EmptyCollectionViewCell.self, forCellWithReuseIdentifier: EmptyCollectionViewCell.identifier)
        
        // mainView.collectionView.delegate = self
        // mainView.collectionView.dataSource = self
        mainView.collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        mainView.collectionView.rx.setDataSource(self)
                .disposed(by: disposeBag)
    }
    
    override func bind() {
        let input = MyPageViewModel.Input()
        let output = viewModel.transform(input)
        
        Observable.combineLatest(output.profile, output.profileImage)
            .observe(on: MainScheduler.instance)
            .bind { [weak self] (profile, image) in
                if let cell = self?.mainView.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? ProfileCollectionViewCell {
                    cell.configure(profile: profile)
                    cell.profileImageView.image = image
                }
            }
            .disposed(by: viewModel.disposeBag)
        
        output.feed
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] images in
                    print("Loaded \(images.count) images")
                    self?.feedImages = images
                    self?.mainView.collectionView.reloadData()
                },
                onError: { error in
                    print("Image loading error: \(error)")
                    AlertManager.shared.showOkayAlert(on: self, title: "데이터 불러오기 실패", message: "이미지 로징에 실패했습니다. 다시 시도해주세요.")
                }
            )
            .disposed(by: viewModel.disposeBag)
        
        mainView.collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                if indexPath.section == 1 { // 이미지 섹션
                    if !self.feedImages.isEmpty && indexPath.row < self.viewModel.postIds.count {
                        let postId = self.viewModel.postIds[indexPath.row]
                        self.fetchAndNavigateToDetailPostViewController(postId: postId)
                    }
                }
            })
            .disposed(by: viewModel.disposeBag)

    }
    
    private func fetchAndNavigateToDetailPostViewController(postId: String) {
        FetchPostsNetworkManager.fetchSpecificPost(id: postId)
            .subscribe { [weak self] result in
                switch result {
                case .success(let post):
                    let detailVC = DetailPostViewController()
                    detailVC.post = post
                    self?.navigationController?.pushViewController(detailVC, animated: true)
                case .failure(let error):
                    print("Failed to load post data: \(error)")
                    AlertManager.shared.showOkayAlert(on: self!, title: "게시물 로딩 실패", message: "게시물을 불러오는 데 실패했습니다. 다시 시도해주세요.")
                }
            }
            .disposed(by: viewModel.disposeBag)
    }
    
    private func configureNavigation() {
        let leftButton = createBarButtonItem(imageName: "gearshape", action: #selector(leftBarButtonTapped))
        
        configureNavigationBar(title: "MY PAGE", leftBarButton: leftButton, rightBarButton: nil)
    }
    
    @objc func leftBarButtonTapped() {
        let vc = SettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MyPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return feedImages.isEmpty ? 1 : feedImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as! ProfileCollectionViewCell
            cell.backgroundColor = .point
            
            cell.editButtonTapped = {
                let vc = EditProfileViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        } else {
            if feedImages.isEmpty {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCollectionViewCell.identifier, for: indexPath) as! EmptyCollectionViewCell
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyFeedImageCollectionViewCell.identifier, for: indexPath) as! MyFeedImageCollectionViewCell
                cell.imageView.image = feedImages[indexPath.row]
                return cell
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}

extension MyPageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        if indexPath.section == 0 {
            return CGSize(width: width, height: 170)
        } else {
            if feedImages.isEmpty {
                return CGSize(width: width, height: 100)
            } else {
                return CGSize(width: 170, height: 170)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
