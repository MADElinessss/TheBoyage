//
//  PostInteractionNetworkManager.swift
//  TheBoyage
//
//  Created by Madeline on 4/28/24.
//

import Alamofire
import Foundation
import RxSwift

struct PostInteractionNetworkManager {
    static func postComment(id: String, query: CommentQuery) -> Single<CommentModel> {
        return Single<CommentModel>.create { single in
            do {
                let urlRequest = try PostInteractionRouter.comment(id: id, query: query).asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: CommentModel.self) { response in
                        print(response)
                        print(response.response?.statusCode)
                        switch response.result {
                        case .success(let success):
                            single(.success(success))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    static func postLike(id: String, query: LikeQuery) -> Single<LikeModel> {
        return Single<LikeModel>.create { single in
            do {
                let urlRequest = try PostInteractionRouter.like(id: id, query: query).asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: LikeModel.self) { response in
                        print(response)
                        print(response.response?.statusCode)
                        switch response.result {
                        case .success(let success):
                            single(.success(success))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
}
