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

    struct Input {
        let nicknameText: ControlProperty<String?>
        let nextButtonTapped: Observable<Void>
    }
    
    struct Output {
        let nicknameValidation: Driver<Bool>
        let nextTransition: Driver<Bool>
    }

    func transform(_ input: Input) -> Output {
        let nicknameValidation = input.nicknameText.orEmpty
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)

        let nextTransition = input.nextButtonTapped
            .withLatestFrom(nicknameValidation)
            .filter { $0 == true }
            .asDriver(onErrorJustReturn: false)

        return Output(nicknameValidation: nicknameValidation, nextTransition: nextTransition)
    }
}
