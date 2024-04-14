//
//  NicknameViewModel.swift
//  TheBoyage
//
//  Created by Madeline on 4/13/24.
//

import Alamofire
import Foundation
import RxCocoa
import RxSwift

class NicknameViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    var centralViewModel: SignUpViewModel
    
    init(centralViewModel: SignUpViewModel) {
        self.centralViewModel = centralViewModel
    }
    
    var email: String?
    var password: String?
    var nickname: String?
    var phoneNumber: String?
    var birthday: String?
    
    struct Input {
        let nicknameText: ControlProperty<String?>
        let phoneNumberText: ControlProperty<String?>
        let birthday: ControlProperty<Date>
        let nextButtonTapped: Observable<Void>
    }
    
    struct Output {
        let nicknameValidation: Driver<Bool>
        let signUpSuccess: Observable<Bool>
        let errorMessage: Observable<String>
    }
    
    func transform(_ input: Input) -> Output {
        let nicknameValidation = input.nicknameText.orEmpty
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        input.nicknameText
            .orEmpty
            .subscribe(onNext: { [weak self] nickname in
                self?.centralViewModel.nickname.onNext(nickname)
                print("Nickname\(nickname)")
            })
            .disposed(by: disposeBag)
        
        // 전화번호 저장
        input.phoneNumberText
            .orEmpty
            .subscribe(onNext: { [weak self] phoneNumber in
                self?.centralViewModel.phoneNumber.onNext(phoneNumber)
                print("Phone Number \(phoneNumber)")
            })
            .disposed(by: disposeBag)
        
        // 생년월일 저장 (문자열로 변환)
        input.birthday
            .map { [weak self] in self?.formatDate($0) }
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] birthdayString in
                self?.centralViewModel.birthday.onNext(birthdayString)
                print("Birthday\(birthdayString)")
            })
            .disposed(by: disposeBag)
        
        let signUpTriggered = input.nextButtonTapped
            .withLatestFrom(nicknameValidation)
            .filter { $0 }
            .do(onNext: { [unowned self] _ in
                self.centralViewModel.signUp()
                print("👩🏻‍🚒 nextbuttontapped")
            })
        
        let errorMessage = Observable<String>.never()
        
        return Output(nicknameValidation: nicknameValidation, signUpSuccess: signUpTriggered, errorMessage: errorMessage)
    }
    
    private func formatDate(_ date: Date?) -> String? {
        guard let date = date else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: date)
    }
    
}
