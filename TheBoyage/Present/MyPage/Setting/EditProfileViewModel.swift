//
//  EditProfileViewModel\.swift
//  TheBoyage
//
//  Created by Madeline on 4/22/24.
//

import Foundation
import RxSwift
import RxCocoa
import PhotosUI
import Kingfisher

class EditProfileViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewLoaded: PublishSubject<Void>
        let imageSelected: PublishSubject<UIImage>
        let saveButtonTapped: ControlEvent<Void>
        let withdrawTrigger: ControlEvent<Void>
        let name: Observable<String>
        let phoneNumber: Observable<String>
        let birthDate: Observable<Date>
    }
    
    struct Output {
        let profileData: Driver<MyProfileModel?>
        let selectedImage: Driver<UIImage?>
        let withdrawalResult: Driver<Bool>
    }
    
    private let profileDataSubject = BehaviorSubject<MyProfileModel?>(value: nil)
    private let selectedImageSubject = BehaviorSubject<UIImage?>(value: nil)
    let uploadResultSubject = PublishSubject<Bool>()
    private let withdrawalResultSubject = PublishSubject<Bool>()
 
    func withdraw() {
        withdrawalResultSubject.onNext(true)
    }
    
    func transform(_ input: Input) -> Output {
        
        input.viewLoaded
            .flatMapLatest { profile -> Observable<MyProfileModel> in
                MyProfileNetworkManager.fetchMyProfile()
                    .asObservable()
                    //.catchAndReturn(nil)
            }
            
            .bind(to: profileDataSubject)
            .disposed(by: disposeBag)
        
        let profileData = profileDataSubject
            .asDriver(onErrorJustReturn: nil)
        
        // 외부에서 받은 이미지 -> Subject
        input.imageSelected
            .bind(to: selectedImageSubject)
            .disposed(by: disposeBag)
        
        input.saveButtonTapped
            .withLatestFrom(Observable.combineLatest(input.name, input.phoneNumber, input.birthDate, input.imageSelected))
            .flatMapLatest { name, phone, birthDate, image -> Observable<Bool> in
                let dateString = FormatterManager.shared.formatDateWithDayToString(date: birthDate)
                guard let imageData = image.jpegData(compressionQuality: 0.5) else { return Observable.just(false) }
                let profile = EditProfileQuery(nick: name, phoneNum: phone, birthDay: dateString, profile: imageData)
                print("profile status: ", phone, dateString)
                return MyProfileNetworkManager.editMyProfile(query: profile)
                    .asObservable()  // Single을 Observable로 변환
                    .debug("saveButtonTapped")
                    .map { result -> Bool in
                        return true
                    }
                    .catchAndReturn(false)
            }
            .bind(to: uploadResultSubject)
            .disposed(by: disposeBag)
        
        input.withdrawTrigger
            .flatMapLatest { self.processWithdrawal() }
            .bind(to: withdrawalResultSubject)
            .disposed(by: disposeBag)
        
        let withdrawalResult = withdrawalResultSubject
            .asDriver(onErrorJustReturn: false)
        
        return Output(profileData: profileData, selectedImage: selectedImageSubject.asDriver(onErrorJustReturn: nil),
                      withdrawalResult: withdrawalResult)

        uploadResultSubject.subscribe(onNext: { success in
            print("Upload success: \(success)")
        }).disposed(by: disposeBag)
        
    }
    
    private func processWithdrawal() -> Observable<Bool> {
        // LoginNetworkManager를 사용하여 회원 탈퇴 요청
        return LoginNetworkManager.withdraw()
            .asObservable()
            .map { withdrawalModel -> Bool in
                true
            }
    }
}
