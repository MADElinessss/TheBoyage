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

class EditProfileViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewLoaded: ControlEvent<Void>
        let imageSelected: PublishSubject<UIImage>
        let saveButtonTapped: ControlEvent<Void>
        let withdrawTrigger: ControlEvent<Void>
    }
    
    struct Output {
        let profileData: Driver<MyProfileModel?>
        let selectedImage: Driver<UIImage?>
        let withdrawalResult: Driver<Bool>
    }
    
    private let profileDataSubject = BehaviorSubject<MyProfileModel?>(value: nil)
    private let selectedImageSubject = BehaviorSubject<UIImage?>(value: nil)
    private let uploadResultSubject = PublishSubject<Bool>()
    private let withdrawalResultSubject = PublishSubject<Bool>()
    
    func withdraw() {
        withdrawalResultSubject.onNext(true)
    }
    
    func transform(_ input: Input) -> Output {
        
        input.viewLoaded
            .flatMapLatest { _ in
                MyProfileNetworkManager.fetchMyProfile()
                    .asObservable()
                    .catchAndReturn(nil)
            }
            .bind(to: profileDataSubject)
            .disposed(by: disposeBag)
        
        let profileData = profileDataSubject
            .asDriver(onErrorJustReturn: nil)
        
        // 외부에서 받은 이미지 -> Subject
        input.imageSelected
            .bind(to: selectedImageSubject)
            .disposed(by: disposeBag)
        
        // BehaviorSubject -> Driver
        let selectedImage = selectedImageSubject
            .asDriver(onErrorJustReturn: nil)
        
        input.withdrawTrigger
            .flatMapLatest { [weak self] _ -> Observable<Bool> in
                guard let self = self else { return .just(false) }
                return self.processWithdrawal()
            }
            .bind(to: withdrawalResultSubject)
            .disposed(by: disposeBag)
        
        let withdrawalResult = withdrawalResultSubject
            .asDriver(onErrorJustReturn: false)
        
        return Output(profileData: profileData, selectedImage: selectedImageSubject.asDriver(onErrorJustReturn: nil),
                      withdrawalResult: withdrawalResult)
        
//        input.saveButtonTapped
//            .withLatestFrom(selectedImageSubject)
//            .compactMap { $0?.jpegData(compressionQuality: 0.8) }
//            .flatMapLatest { imageData in
//                self.uploadImageData(imageData)
//            }
//            .bind(to: uploadResultSubject)
//            .disposed(by: disposeBag)
        
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
    
//    private func uploadImageData(_ data: Data) -> Observable<Bool> {
//        MyProfileNetworkManager.editMyProfile(query: <#T##EditProfileQuery#>)
//        return Observable.just(true)
//    }
}
