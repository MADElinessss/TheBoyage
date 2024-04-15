//
//  SignUpViewModel.swift
//  TheBoyage
//
//  Created by Madeline on 4/14/24.
//

import Alamofire
import Foundation
import RxCocoa
import RxSwift

class SignUpViewModel {

    let email = BehaviorSubject<String?>(value: nil)
    let password = BehaviorSubject<String?>(value: nil)
    let nickname = BehaviorSubject<String?>(value: nil)
    let phoneNumber = BehaviorSubject<String?>(value: nil)
    let birthday = BehaviorSubject<String?>(value: nil)
    
    var disposeBag = DisposeBag()
    
    func signUp() {
       
        Observable.combineLatest(
            email.asObservable(), password.asObservable(),
            nickname.asObservable(), phoneNumber.asObservable(),
            birthday.asObservable()
        )
        .take(1) // 단 한 번만 구독하고 구독을 해제합니다.
        .subscribe(onNext: { [weak self] email, password, nickname, phoneNumber, birthday in
            self?.logValues(email: email, password: password, nickname: nickname, phoneNumber: phoneNumber, birthday: birthday)
                        
            guard let email = email, let password = password, let nickname = nickname,
                  let phoneNumber = phoneNumber, let birthday = birthday else {
                print("모든 입력이 완료되지 않았습니다.")
                return
            }
            
            let signUpQuery = SignUpQuery(email: email, password: password, nick: nickname, birthDay: birthday, phoneNum: phoneNumber)
            
            NetworkManager.signUp(query: signUpQuery)
                .subscribe(onSuccess: { signup in
                    print("회원가입 성공: \(signup.user_id), \(signup.email), \(signup.nick)")
                }, onFailure: { error in
                    print("회원가입 실패: \(error.localizedDescription)")
                })
                .disposed(by: self?.disposeBag ?? DisposeBag())
        })
        .disposed(by: disposeBag)
    }
    
    private func logValues(email: String?, password: String?, nickname: String?, phoneNumber: String?, birthday: String?) {
        print("🔍 Current Values:")
        print("Email: \(email ?? "nil")")
        print("Password: \(password ?? "nil")")
        print("Nickname: \(nickname ?? "nil")")
        print("Phone Number: \(phoneNumber ?? "nil")")
        print("Birthday: \(birthday ?? "nil")")
    }
}
