//
//  SignUpViewModel.swift
//  TheBoyage
//
//  Created by Madeline on 4/13/24.
//

import Alamofire
import Foundation
import RxCocoa
import RxSwift

class EmailViewModel: ViewModelType {
    
    var centralViewModel: SignUpViewModel
    var disposeBag = DisposeBag()
    
    init(centralViewModel: SignUpViewModel) {
        self.centralViewModel = centralViewModel
    }
    
    struct Input {
        let emailText: ControlProperty<String?>
        let nextButtonTapped: Observable<Void>
    }
    
    struct Output {
        let email: Driver<String>
        let emailValidation: Driver<Bool>
        let nextTransition: Observable<Bool>
        let errorMessage: Driver<String?>
    }
    
    private let errorMessageSubject = PublishSubject<String?>()
    
    func transform(_ input: Input) -> Output {
        
        let email = input.emailText.orEmpty.asDriver()
        
        let emailValidation = input.emailText.orEmpty
            .map { $0.count >= 5 && $0.contains("@") }
            .asDriver(onErrorJustReturn: false)
        
        let nextTransition = input.nextButtonTapped
            .withLatestFrom(input.emailText.orEmpty)
            .filter { $0.count >= 5 && $0.contains("@") }
            .do(onNext: { [weak self] email in
                self?.centralViewModel.email.onNext(email)
                print("EmailViewModel Email: \(email)")
            })
            .flatMapLatest { email in
                LoginNetworkManager.emailValidation(query: EmailQuery(email: email))
                    .do(onSuccess: { response in
                        if response.message != "사용 가능한 이메일입니다." {
                            self.errorMessageSubject.onNext(response.message)
                        }
                    }, onError: { _ in
                        self.errorMessageSubject.onNext("네트워크 오류가 발생했습니다.")
                    })
                    .map { response -> Bool in
                        response.message == "사용 가능한 이메일입니다."
                    }
                    .asDriver(onErrorJustReturn: false)
            }
        
        return Output(email: email, emailValidation: emailValidation, nextTransition: nextTransition, errorMessage: errorMessageSubject.asDriver(onErrorJustReturn: nil))
    }
}
