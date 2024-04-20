//
//  PasswordViewController.swift
//  TheBoyage
//
//  Created by Madeline on 4/13/24.
//

import UIKit

class PasswordViewController: BaseViewController {

    let titleLabel = UILabel()
    let passwordTextField = {
        let view = UITextField()
        view.placeholder = " 비밀번호"
        view.font = .systemFont(ofSize: 14, weight: .medium)
        view.textColor = .black
        view.backgroundColor = .white
        view.layer.borderWidth = 0.3
        view.tintColor = .lightGray
        view.isSecureTextEntry = true
        view.textContentType = .password
        return view
    }()
    let descriptionLabel = UILabel()
    let nextButton = {
        let view = PointButton(title: "다음")
        view.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        return view
    }()
    
    private let progressView = ProgressView(numberOfSteps: 3)
    
    var viewModel: PasswordViewModel!
    
    init(centralViewModel: SignUpViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = PasswordViewModel(centralViewModel: centralViewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.becomeFirstResponder()
        configure()
        configureNavigationBar()
    }
    
    override func bind() {
        let input = PasswordViewModel.Input(passwordText: passwordTextField.rx.text, nextButtonTapped: nextButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input)
        
        output.nextTransition
            .drive(with: self) { owner, isValid in
                if isValid {
                    owner.goToNextPage()
                }
            }
            .disposed(by: disposeBag)
    }
    
    func goToNextPage() {
        (parent as? SignUpViewController)?.showNextPage(currentIndex: 1)
    }
    
    private func configureNavigationBar() {
        title = "회원 가입"
        navigationController?.title = title
    }
    
    private func configure() {
        view.addSubview(titleLabel)
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
        view.addSubview(descriptionLabel)
        view.addSubview(progressView)
    
        titleLabel.text = "비밀번호를 입력해주세요."
        titleLabel.numberOfLines = 2
        titleLabel.font = .systemFont(ofSize: 16, weight: .regular)

        descriptionLabel.font = .systemFont(ofSize: 12, weight: .regular)
        descriptionLabel.textColor = .red
        descriptionLabel.isHidden = true
        
        updateProgress(currentStep: 2)
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.left.right.equalTo(view)
            make.height.equalTo(4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.height.equalTo(48)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(24)
        }
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
    }
    
    func updateProgress(currentStep: Int) {
        progressView.updateProgress(currentStep: currentStep)
    }
}
