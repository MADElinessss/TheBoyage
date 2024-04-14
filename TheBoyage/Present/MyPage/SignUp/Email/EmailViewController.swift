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
   
    private let progressView = ProgressView(numberOfSteps: 3)
    var viewModel: EmailViewModel!
    
    init(centralViewModel: SignUpViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = EmailViewModel(centralViewModel: centralViewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
            .bind(with: self) { owner, isNext in
                if isNext {
                    owner.goToNextPage()
                } else {
                    owner.descriptionLabel.text = "중복된 이메일입니다."
                    owner.descriptionLabel.isHidden = false
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
        view.addSubview(progressView)
        
        titleLabel.text = "로그인에 사용할\n아이디를 입력해주세요."
        titleLabel.numberOfLines = 2
        titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.font = .systemFont(ofSize: 12, weight: .regular)
        descriptionLabel.textColor = .red
        descriptionLabel.isHidden = true
        
        updateProgress(currentStep: 1)
        
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
    
    func updateProgress(currentStep: Int) {
        progressView.updateProgress(currentStep: currentStep)
    }
}
