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
        let profile: MyProfileModel
    }
    
    struct Output {
        let profile: Observable<MyProfileModel>
        let image: Observable<UIImage>
        let feed: Observable<MyProfileModel>
    }
    
    let loginRequired = PublishSubject<Bool>()
    
    func transform(_ input: Input) -> Output {
        let profile = fetchProfile().asObservable()
        let image = loadImage(from: input.profile.profileImage)
        let feed = fetchFeed().asObservable()
        
        feed.subscribe(onError: { error in
                if let afError = error as? AFError, afError.isResponseSerializationError {
                    self.loginRequired.onNext(true)
                }
            }).disposed(by: disposeBag)
        
        
        return Output(profile: profile, image: image, feed: feed)
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
    func fetchProfile() -> Observable<MyProfileModel> {
        return MyProfileNetworkManager.fetchMyProfile()
            .asObservable()
            .compactMap { $0 } // nil을 제거
            .do { profile in
                print("profile: ", profile)
            } onError: { error in
                print("profile error: ", error)
            }

    }
    /*
     에러
     Cannot convert return expression of type 'Observable<MyProfileModel?>' to return type 'Observable<MyProfileModel>' -> compactMap
     */
    
    private func loadImage(from imageName: String?) -> Observable<UIImage> {
        guard let imageName = imageName,
              let url = URL(string: APIKey.baseURL.rawValue + "/v1/" + imageName) else {
            return .just(UIImage(systemName: "airplane.departure")!)
        }
        
        return Observable<UIImage>.create { observer in
            let header = AnyModifier { request in
                var request = request
                request.setValue(UserDefaults.standard.string(forKey: "AccessToken") ?? "", forHTTPHeaderField: HTTPHeader.authorization.rawValue)
                request.setValue(APIKey.sesacKey.rawValue, forHTTPHeaderField: HTTPHeader.sesacKey.rawValue)
                return request
            }

            let task = KingfisherManager.shared.retrieveImage(
                with: .network(url),
                options: [.requestModifier(header)],
                completionHandler: { result in
                    switch result {
                    case .success(let value):
                        observer.onNext(value.image)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            )
            
            return Disposables.create {
                task?.cancel() // 다운로드 작업 취소
            }
        }
    }
    
}
