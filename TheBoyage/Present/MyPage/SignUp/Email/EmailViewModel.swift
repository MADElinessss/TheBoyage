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
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let emailText: ControlProperty<String?>
        let nextButtonTapped: Observable<Void>
    }
    
    struct Output {
        let email: Driver<String>
        let emailValidation: Driver<Bool>
        let nextTransition: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        
        let email = input.emailText.orEmpty.asDriver()
        
        let emailValidation = input.emailText.orEmpty
            .map { $0.count >= 5 && $0.contains("@") }
            .asDriver(onErrorJustReturn: false)
        
        let nextTransition = input.nextButtonTapped
            .withLatestFrom(emailValidation)
            .filter { $0 == true }
            .asDriver(onErrorJustReturn: false)
        
        return Output(email: email, emailValidation: emailValidation, nextTransition: nextTransition)
    }
}
