//
//  EtcViewController.swift
//  TheBoyage
//
//  Created by Madeline on 4/13/24.
//

import RxCocoa
import RxSwift
import UIKit

class EtcViewController: BaseViewController {
    
    let titleLabel = UILabel()
    let nicknameTextField = {
        let view = UITextField()
        view.placeholder = " 닉네임"
        view.font = .systemFont(ofSize: 14, weight: .medium)
        view.textColor = .black
        view.backgroundColor = .white
        view.layer.borderWidth = 0.3
        view.tintColor = .lightGray
        return view
    }()
    let phoneTextField = {
        let view = UITextField()
        view.placeholder = " 휴대폰 번호"
        view.font = .systemFont(ofSize: 14, weight: .medium)
        view.textColor = .black
        view.backgroundColor = .white
        view.layer.borderWidth = 0.3
        view.tintColor = .lightGray
        view.keyboardType = .numberPad
        return view
    }()
    let birthdatTitle = {
        let view = UILabel()
        view.text = "생일을 입력해주세요."
        view.font = .systemFont(ofSize: 16, weight: .light)
        view.textColor = .black
        return view
    }()
    let birthdayPicker = {
        let view = UIDatePicker()
        view.tintColor = .point
        view.datePickerMode = .date
        view.preferredDatePickerStyle = .automatic
        view.locale = Locale(identifier: "ko_KR")
        return view
    }()
    let descriptionLabel = UILabel()
    let nextButton = {
        let view = PointButton(title: "다음")
        view.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        return view
    }()
    
    private let progressView = ProgressView(numberOfSteps: 3)

    var viewModel: NicknameViewModel!
    
    init(centralViewModel: SignUpViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = NicknameViewModel(centralViewModel: centralViewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nicknameTextField.becomeFirstResponder()
        configure()
        configureNavigationBar()
    }
    
    override func bind() {
        let input = NicknameViewModel.Input(nicknameText: nicknameTextField.rx.text, phoneNumberText: phoneTextField.rx.text, birthday: birthdayPicker.rx.date, nextButtonTapped: nextButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input)
        
        output.nicknameValidation
            .drive(with: self) { owner, isValid in
                self.nextButton.isEnabled = isValid
                self.nextButton.backgroundColor = isValid ? .point : .lightGray
            }
            .disposed(by: disposeBag)
        
        output.signUpSuccess
            .subscribe(with: self, onNext: { owner, isNext in
                let vc = MyPageViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func configure() {
        view.addSubview(titleLabel)
        view.addSubview(nicknameTextField)
        view.addSubview(phoneTextField)
        view.addSubview(birthdayPicker)
        view.addSubview(birthdatTitle)
        view.addSubview(nextButton)
        view.addSubview(descriptionLabel)
        view.addSubview(progressView)
        
        titleLabel.text = "닉네임, 휴대폰 번호, 생일을 입력해주세요."
        titleLabel.numberOfLines = 2
        titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        
        updateProgress(currentStep: 3)
        
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
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        
        birthdatTitle.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        
        birthdayPicker.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
            make.width.equalTo(200)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(birthdayPicker.snp.bottom).offset(44)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
    }
    
    private func configureNavigationBar() {
        title = "회원 가입"
        navigationController?.title = title
    }
    
    func updateProgress(currentStep: Int) {
        progressView.updateProgress(currentStep: currentStep)
    }

}
