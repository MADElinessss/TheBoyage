//
//  PasswordViewModel.swift
//  TheBoyage
//
//  Created by Madeline on 4/13/24.
//

import Alamofire
import Foundation
import RxCocoa
import RxSwift

class PasswordViewModel: ViewModelType {
    var disposeBag = DisposeBag()

    struct Input {
        let passwordText: ControlProperty<String?>
        let nextButtonTapped: Observable<Void>
    }
    
    struct Output {
        let passwordValidation: Driver<Bool>
        let nextTransition: Driver<Bool>
    }

    func transform(_ input: Input) -> Output {
        let passwordValidation = input.passwordText.orEmpty
            .map { $0.count >= 6 }
            .asDriver(onErrorJustReturn: false)

        let nextTransition = input.nextButtonTapped
            .withLatestFrom(passwordValidation)
            .filter { $0 == true }
            .asDriver(onErrorJustReturn: false)

        return Output(passwordValidation: passwordValidation, nextTransition: nextTransition)
    }
}
