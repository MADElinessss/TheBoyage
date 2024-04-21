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
        
        configureNavigation()
    }
    
    
    override func bind() {
        let input = MyPageViewModel()
        let output = viewModel.fetchProfile()
            .subscribe(with: self) { owner, profile in
                self.mainView.profile.configure(profile: profile)
            }
    }
    
    private func configureNavigation() {
        let leftButton = createBarButtonItem(imageName: "gearshape", action: #selector(leftBarButtonTapped))
        
        configureNavigationBar(title: "MY PAGE", leftBarButton: leftButton, rightBarButton: nil)
    }
    
    @objc func leftBarButtonTapped() {
        
    }
    
}
