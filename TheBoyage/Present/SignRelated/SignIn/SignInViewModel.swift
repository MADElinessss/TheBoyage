//
//  SignInViewModel.swift
//  TheBoyage
//
//  Created by Madeline on 4/12/24.
//

import Alamofire
import Foundation
import RxCocoa
import RxSwift

class SignInViewModel: ViewModelType {
    
     var disposeBag = DisposeBag()
    
    struct Input {
        let emailText: Observable<String>
        let passwordText: Observable<String>
        let signInButtonTapped: Observable<Void>
        let signUpButtonTapped: Observable<Void>
    }
    
    struct Output {
        let signInValidation: Driver<Bool>
        let loginSuccessTrigger: Driver<Void>
        let signUpButtonTapped: Observable<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let signInValid = BehaviorRelay(value: false)
        let signInSuccess = PublishRelay<Void>()
        
        let signInObservable = Observable
            .combineLatest(input.emailText, input.passwordText)
            .map { email, password in
                // 공백 없애주기
                return LoginQuery(email: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password)
            }
           
        signInObservable
            .bind(with: self) { owner, login in
                if login.email.contains("@") && login.password.count > 5 {
                    signInValid.accept(true)
                } else {
                    signInValid.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input.signInButtonTapped
            .withLatestFrom(signInObservable)
            .debug("2")
            //.debounce(.seconds(1), scheduler: MainScheduler.instance)
            .debug("3")
            .flatMapLatest { loginQuery in
                return LoginNetworkManager.createLogin(query: loginQuery)
                    .asDriver(onErrorJustReturn: LoginModel(accessToken: "", refreshToken: "", user_id: ""))
            }
            .debug("4")
            .subscribe(with: self) { owner, loginModel in
                if !loginModel.accessToken.isEmpty {
                    signInSuccess.accept(())
                } else {
                    print("Login failed: No access token")
                }
                // signInSuccess.accept(())
            } onError: { owner, error in
                print("삐용", error)
            } onCompleted: { owner in
                print("completed")
            }
            .disposed(by: disposeBag)
        
        input.signUpButtonTapped
            .subscribe(with: self) { owner, _ in
                
            } onError: { owner, error in
                print("삐용", error)
            }
            .disposed(by: disposeBag)
        
        return Output(signInValidation: signInValid.asDriver(), loginSuccessTrigger: signInSuccess.asDriver(onErrorJustReturn: ()), signUpButtonTapped: input.signUpButtonTapped.asObservable())
    }
    
}
