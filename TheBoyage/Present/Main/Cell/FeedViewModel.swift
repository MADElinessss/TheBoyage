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
    
    var post: Posts?
    
    struct Input {
        let post: Posts
        
    }
    
    let postDeleted = PublishSubject<Void>()
    
    struct Output {
        let feedImage: Observable<UIImage>
        let profileImage: Observable<UIImage>
    }
    
    func transform(_ input: Input) -> Output {
        let image = loadImage(from: input.post.files.first)
        let profile = loadImage(from: input.post.creator.profileImage)
        
        return Output(feedImage: image, profileImage: profile)
    }

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
    
    func deletePost(postId: String) -> Observable<Void> {
        return PostNetworkManager.deleteContent(postId: postId)
            .asObservable()
            .do(onNext: { [weak self] _ in
                self?.postDeleted.onNext(())
            }, onError: { error in
                print("Deletion error: \(error)")
            })
    }

}
