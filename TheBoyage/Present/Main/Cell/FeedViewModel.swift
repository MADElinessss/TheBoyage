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
    var imageLoadedCallback: ((UIImage) -> Void)?
    
    struct Input {
        let post: Posts
        
    }
    
    let postDeleted = PublishSubject<Void>()
    
    struct Output {
        let feedImage: Observable<UIImage>
        let profileImage: Observable<UIImage>
    }
    
    func transform(_ input: Input) -> Output {
        let image = ImageService.shared.loadImage(from: input.post.files.first)
        let profile = ImageService.shared.loadImage(from: input.post.creator.profileImage)
        
        return Output(feedImage: image, profileImage: profile)
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
