//
//  SignInViewController.swift
//  TheBoyage
//
//  Created by Madeline on 4/11/24.
//

import SnapKit
import UIKit
import RxCocoa
import RxSwift

class SignInViewController: BaseViewController {

    let mainView = SignInView()
    let viewModel = SignInViewModel()
    
    override func loadView() {
        view = mainView
        mainView.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureNavigationBar()
        configure()
        //bind()
    }
    
    override func bind() {
        let input = SignInViewModel.Input(
            emailText: mainView.emailTextField.rx.text.orEmpty.asObservable(),
            passwordText: mainView.passwordTextField.rx.text.orEmpty.asObservable(),
            signInButtonTapped: mainView.signInButton.rx.tap.asObservable(), signUpButtonTapped: mainView.signUpButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        output.loginSuccessTrigger
            .drive(with: self) { owner, _ in
                print("👩🏻‍🚒 view - lst")
                let vc = MyPageViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
            
        output.signUpButtonTapped
            .subscribe(with: self, onNext: { owner, _ in
                print("👩🏻‍🚒 view - sbt")
                let vc = SignUpViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        
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
            make.top.equalTo(mainView.passwordTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        
        mainView.signUpButton.snp.makeConstraints { make in
            make.top.equalTo(mainView.signInButton.snp.bottom).offset(48)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
    }
    
    private func configureNavigationBar() {
        title = "LOGIN"
        navigationController?.title = title
    }
}
