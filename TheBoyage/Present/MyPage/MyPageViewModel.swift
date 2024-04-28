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
                return ImageService.shared.loadImage(from: ids)
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
                        ImageService.shared.loadImage(from: fileName)
                    }
                    return Observable.zip(imageLoadObservables)
                }
        }
        return Observable.zip(imageObservables).map { $0.flatMap { $0 } }
    }

}
