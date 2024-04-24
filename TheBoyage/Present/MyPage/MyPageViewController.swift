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
        bindViewModel()
    }
    
    private func configureView() {
        mainView.collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        mainView.collectionView.register(MyFeedImageCollectionViewCell.self, forCellWithReuseIdentifier: MyFeedImageCollectionViewCell.identifier)
        mainView.collectionView.register(EmptyCollectionViewCell.self, forCellWithReuseIdentifier: EmptyCollectionViewCell.identifier)
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    
    private func bindViewModel() {
        let input = MyPageViewModel.Input()
        let output = viewModel.transform(input)
        
        output.profile
            .observe(on: MainScheduler.instance)
            .bind { [weak self] profile in
                if let cell = self?.mainView.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? ProfileCollectionViewCell {
                    cell.configure(profile: profile)
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
                }
            )
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
            return cell
        } else {
            if feedImages.isEmpty {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCollectionViewCell.identifier, for: indexPath) as! EmptyCollectionViewCell
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyFeedImageCollectionViewCell.identifier, for: indexPath) as! MyFeedImageCollectionViewCell
                cell.imageView.image = feedImages[indexPath.row]
                cell.backgroundColor = .yellow
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
            return CGSize(width: width, height: 200)
        } else {
            if feedImages.isEmpty {
                return CGSize(width: width, height: 100)
            } else {
                return CGSize(width: width, height: 150)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
