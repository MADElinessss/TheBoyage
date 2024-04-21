//
//  MyPageViewModel.swift
//  TheBoyage
//
//  Created by Madeline on 4/21/24.
//

import Alamofire
import Foundation
import RxCocoa
import RxSwift

class MyPageViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let profile: MyProfileModel
    }
    
    struct Output {
        let profile: Observable<MyProfileModel>
    }
    
    func transform(_ input: Input) -> Output {
        let profile = fetchProfile().asObservable()
       return Output(profile: profile)
    }
    
    func fetchProfile() -> Observable<MyProfileModel> {
        return MyProfileNetworkManager.fetchMyProfile()
            .asObservable()
            .do { profile in
                print("profile: ", profile)
            } onError: { error in
                print("profile error: ", error)
            }

    }
    
    
}
