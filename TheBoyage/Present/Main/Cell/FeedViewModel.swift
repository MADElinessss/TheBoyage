//
//  FeedViewModel.swift
//  TheBoyage
//
//  Created by Madeline on 4/23/24.
//

import Foundation
import Kingfisher
import RxSwift
import RxCocoa
import UIKit


class FeedViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let post: Posts
    }
    
    struct Output {
        let feedImage: Observable<UIImage>
        let profileImage: Observable<UIImage>
//        let post: Observable<FetchModel>
    }
    
    func transform(_ input: Input) -> Output {
//        let post = fetchPost().asObservable()
        let image = loadImage(from: input.post.files.first)
        let profile = loadImage(from: input.post.creator.profileImage)
        
        return Output(feedImage: image, profileImage: profile)
    }
    
//    func fetchPost() -> Observable<FetchModel> {
//        let query = FetchPostQuery(limit: "7", product_id: "boyager_general")
//        return FetchPostsNetworkManager.fetchPost(query: query)
//            .asObservable()
//            .compactMap { $0 }
//        // 에러 처리
//    }
    
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
                    print("🥹image completion", result)
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
