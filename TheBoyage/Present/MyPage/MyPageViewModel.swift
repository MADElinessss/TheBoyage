//
//  MyPageViewModel.swift
//  TheBoyage
//
//  Created by Madeline on 4/21/24.
//

import Alamofire
import RxCocoa
import RxSwift
import UIKit
import Kingfisher

class MyPageViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
    }
    
    struct Output {
        let profile: Observable<MyProfileModel>
        let feed: Observable<[UIImage]>
    }
    
    let loginRequired = PublishSubject<Bool>()
    
    func transform(_ input: Input) -> Output {
        let profile = fetchProfile().asObservable()
        let feedImages = profile
            .flatMap { profile -> Observable<[UIImage]> in
                let imageUrls = profile.posts ?? []
                return self.fetchImages(from: imageUrls)
            }
        
        return Output(profile: profile, feed: feedImages)
    }
    
    func fetchProfile() -> Observable<MyProfileModel> {
        return MyProfileNetworkManager.fetchMyProfile()
            .asObservable()
            .compactMap { $0 }
    }
    
    func fetchFeed() -> Observable<MyProfileModel> {
        
        return MyProfileNetworkManager.fetchMyProfile()
            .asObservable()
            .do(onNext: { response in
                print("🥹response: \(response)")
            }, onError: { [weak self] error in
                print("🥹feed Error \(error.localizedDescription)")
                if let afError = error as? AFError, afError.isResponseSerializationError {
                    
                    if let statusCode = afError.responseCode {
                        print("-------- error \(statusCode)------------")
                        switch statusCode {
                        case 403, 419:  // 토큰 만료
                            self?.loginRequired.onNext(true)
                        default:
                            break  // 다른 상태 코드에 대한 처리는 필요에 따라 추가
                        }
                    }
                }
            })
    }
    
    // TODO: 프로필 이미지 아직 없음 -> 이제 있음
//    func fetchProfile() -> Observable<MyProfileModel> {
//        return MyProfileNetworkManager.fetchMyProfile()
//            .asObservable()
//            .compactMap { $0 } // nil을 제거
//            .do { profile in
//                print("profile: ", profile)
//            } onError: { error in
//                print("profile error: ", error)
//            }
//
//    }
    /*
     에러
     Cannot convert return expression of type 'Observable<MyProfileModel?>' to return type 'Observable<MyProfileModel>' -> compactMap
     */
    
    func fetchImages(from urls: [String]) -> Observable<[UIImage]> {
        let requests = urls.map { url -> Observable<UIImage> in
            return Observable<UIImage>.create { observer in
                let resource = ImageResource(downloadURL: URL(string: url)!, cacheKey: url)
                KingfisherManager.shared.retrieveImage(with: resource) { result in
                    switch result {
                    case .success(let value):
                        observer.onNext(value.image)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
                return Disposables.create()
            }
        }
        return Observable.zip(requests)
    }
}
