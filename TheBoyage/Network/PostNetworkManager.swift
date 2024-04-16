//
//  PostNetworkManager.swift
//  TheBoyage
//
//  Created by Madeline on 4/16/24.
//

import Alamofire
import Foundation
import RxSwift

struct PostNetworkManager {
    static func imageUpload(query: ImageUploadQuery) -> Single<PostModel> {
        return Single<PostModel>.create { single in
            do {
                let urlRequest = try PostRouter.imageUpload(query: query).asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: PostModel.self) { response in
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
