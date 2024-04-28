//
//  DetailViewModel.swift
//  TheBoyage
//
//  Created by Madeline on 4/28/24.
//

import Foundation
import UIKit
import RxSwift

class DetailViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    let likeButtonPressed = PublishSubject<String>()
    let commentSubmitted = PublishSubject<(String, String)>()//ID, comment
    let isLiked = BehaviorSubject<Bool>(value: false)
    
    struct Input {
        let post: Posts
        let likeButtonPressed: Observable<Void>
        let commentText: Observable<String>
    }
    
    struct Output {
        let image: Observable<UIImage>
    }
    
    func transform(_ input: Input) -> Output {
        let image = ImageService.shared.loadImage(from: input.post.files.first)
        return Output(image: image)
    }
    
    func postComment() {
        commentSubmitted.flatMap { [weak self] postId, commentText -> Observable<CommentModel> in
            guard self != nil else { return .empty() }
            let commentQuery = CommentQuery(content: commentText)
            
            return PostInteractionNetworkManager.postComment(id: postId, query: commentQuery)
                   .asObservable()
        }
        .subscribe(onNext: { response in
            print("Response: \(response)")
        }, onError: { error in
            print("Error: \(error)")
        }).disposed(by: disposeBag)
    }

}
