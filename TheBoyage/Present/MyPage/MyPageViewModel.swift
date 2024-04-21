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
    }
    
    func transform(_ input: Input) -> Output {
        let profile = fetchProfile().asObservable()
        let image = loadImage(from: input.profile.profileImage)
        return Output(profile: profile, image: image)
    }
    
    // TODO: 프로필 이미지 아직 없음
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

            KingfisherManager.shared.retrieveImage(
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

            return Disposables.create()
        }
    }
    
}
