//
//  CommentViewModel.swift
//  TheBoyage
//
//  Created by Madeline on 4/28/24.
//

import Foundation
import RxSwift

class CommentViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    let commentSubmitted = PublishSubject<(String, String)>() // (Post ID, Comment Content)
    let commentsUpdated = PublishSubject<Void>()
    
    struct Input {
        let postId: String
        let commentText: Observable<String>
        let submitComment: Observable<Void>
    }
    
    struct Output {
        let result: Observable<String>
    }
    
    func transform(_ input: Input) -> Output {
        let result = input.submitComment
            .withLatestFrom(input.commentText)
            .flatMapLatest { [weak self] commentText -> Observable<String> in
                guard let self = self else { return .just("error") }
                return self.submitComment(postId: input.postId, commentText: commentText)
            }
        
        return Output(result: result)
    }
    
    private func submitComment(postId: String, commentText: String) -> Observable<String> {
        let commentQuery = CommentQuery(content: commentText)
        
        return PostInteractionNetworkManager.postComment(id: postId, query: commentQuery)
            .map { response -> String in
                self.commentsUpdated.onNext(())
                return "Success: \(response)"
            }
            .catch { error in
                    .just("Failed to post comment: \(error.localizedDescription)")
            }
            .asObservable()
    }
}
