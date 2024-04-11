//
//  SignInViewController.swift
//  TheBoyage
//
//  Created by Madeline on 4/11/24.
//

import SnapKit
import UIKit

class SignInViewController: BaseViewController {

    let mainView = SignInView()
    
    override func loadView() {
        view = mainView
        mainView.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureNavigationBar()
        configure()
    }
    
    private func configure() {
        
        mainView.emailTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(44)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        
        mainView.passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(mainView.emailTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        
        mainView.signInButton.snp.makeConstraints { make in
            make.top.equalTo(mainView.passwordTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        
    }
    
    private func configureNavigationBar() {
        title = "LOGIN"
        navigationController?.title = title
    }
}
