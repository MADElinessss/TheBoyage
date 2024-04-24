//
//  MyPageViewController.swift
//  TheBoyage
//
//  Created by Madeline on 4/13/24.
//

import UIKit

class MyPageViewController: BaseViewController {

    let mainView = MyPageView()
    let viewModel = MyPageViewModel()
    
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
    }
    
    override func bind() {
        
        // TODO: input, output 다시 지정
        
        let output = viewModel.fetchProfile()
            .subscribe(with: self) { owner, profile in
                self.mainView.profile.configure(profile: profile)
            }
        
        mainView.profile.editButton.rx.tap
            .subscribe { _ in
                let vc = EditProfileViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
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
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as! ProfileCollectionViewCell
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyFeedImageCollectionViewCell.identifier, for: indexPath) as! MyFeedImageCollectionViewCell
            
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}
