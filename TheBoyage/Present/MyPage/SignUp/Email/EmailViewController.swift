//
//  EmailViewController.swift
//  TheBoyage
//
//  Created by Madeline on 4/13/24.
//

import UIKit

class EmailViewController: BaseViewController {

    let titleLabel = UILabel()
    let emailTextField = {
        let view = UITextField()
        view.placeholder = " 아이디(이메일)"
        view.font = .systemFont(ofSize: 14, weight: .medium)
        view.textColor = .black
        view.backgroundColor = .white
        view.layer.borderWidth = 0.3
        view.tintColor = .lightGray
        return view
    }()
    let descriptionLabel = UILabel()
    let nextButton = {
        let view = PointButton(title: "다음")
        view.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        return view
    }()
   
    let viewModel = EmailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.becomeFirstResponder()
        configure()
        configureNavigationBar()
    }

    override func bind() {
        let input = EmailViewModel.Input(emailText: emailTextField.rx.text, nextButtonTapped: nextButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input)
        output.emailValidation
            .drive(with: self) { owner, isValid in
                owner.nextButton.isEnabled = isValid
                owner.nextButton.backgroundColor = isValid ? .point : .lightGray
                owner.descriptionLabel.isHidden = isValid
                owner.descriptionLabel.text = isValid ? "" : "이메일 형식이 올바르지 않습니다."
            }
            .disposed(by: disposeBag)
        
        output.nextTransition
            .drive(with: self) { owner, isNext in
                if isNext {
                    owner.goToNextPage()
                }
            }
            .disposed(by: disposeBag)
    }
    
    func goToNextPage() {
        (parent as? SignUpViewController)?.showNextPage(currentIndex: 0)
    }
    
    private func configureNavigationBar() {
        title = "회원 가입"
        navigationController?.title = title
    }
    
    private func configure() {
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(nextButton)
        view.addSubview(descriptionLabel)
        
        titleLabel.text = "로그인에 사용할\n아이디를 입력해주세요."
        titleLabel.numberOfLines = 2
        titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        
//        descriptionLabel.text = "동일한 이메일 주소로 가입된 SNS 계정이 있습니다. 기존 계정으로 로그인해주세요."
        // descriptionLabel.text = "이메일 형식이 올바르지 않습니다."
        descriptionLabel.font = .systemFont(ofSize: 12, weight: .regular)
        descriptionLabel.textColor = .red
        descriptionLabel.isHidden = true
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(24)
        }
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
    }
    
}
