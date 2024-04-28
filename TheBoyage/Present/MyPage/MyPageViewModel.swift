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
    var postIds: [String] = []
    
    struct Input {
    }
    
    struct Output {
        let profile: Observable<MyProfileModel>
        let profileImage: Observable<UIImage>
        let feed: Observable<[UIImage]>
    }
    
    let loginRequired = PublishSubject<Bool>()
    
    func transform(_ input: Input) -> Output {
        let profile = fetchProfile().asObservable()
        let feedImages = profile
            .flatMapLatest { profile -> Observable<[UIImage]> in
                guard let ids = profile.posts else {
                    return Observable.just([])
                }
                return self.fetchImages(from: ids)
            }
        let profileImage = profile
            .flatMapLatest { profile -> Observable<UIImage> in
                guard let ids = profile.profileImage else {
                    return Observable.just(UIImage(systemName: "person")!)
                }
                return self.loadImage(from: ids)
            }
        return Output(profile: profile, profileImage: profileImage, feed: feedImages)
    }
    
    func fetchProfile() -> Observable<MyProfileModel> {
        return MyProfileNetworkManager.fetchMyProfile()
            .asObservable()
            .compactMap { $0 }
    }

    func fetchFeed(id: String) -> Observable<Posts> {
        return FetchPostsNetworkManager.fetchSpecificPost(id: id)
            .asObservable()
            .do(onNext: { response in
                print("Fetched post response: \(response)")
            }, onError: { error in
                print("Error fetching post: \(error)")
            })
    }
    
    func fetchImages(from postIDs: [String]) -> Observable<[UIImage]> {
        postIds = postIDs
        let imageObservables = postIDs.map { postID in
            fetchFeed(id: postID)
                .flatMap { post -> Observable<[UIImage]> in
                    let imageLoadObservables = post.files.map { fileName in
                        // self.loadImage(from: fileName)
                        ImageService.shared.loadImage(from: fileName)
                    }
                    return Observable.zip(imageLoadObservables)
                }
        }
        return Observable.zip(imageObservables).map { $0.flatMap { $0 } }
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
            
            return Disposables.create()
        }
    }

}
