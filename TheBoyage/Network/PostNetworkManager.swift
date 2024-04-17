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
    static func imageUpload(query: ImageUploadQuery) -> Single<ImageUploadModel> {
        let url = URL(string: APIKey.baseURL.rawValue + "/v1/posts/files")!
        let headers: HTTPHeaders = [
            HTTPHeader.authorization.rawValue : UserDefaults.standard.string(forKey: "AccessToken") ?? "",
            HTTPHeader.contentType.rawValue : HTTPHeader.multipart.rawValue,
            HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue
        ]
        return Single<ImageUploadModel>.create { single in
            do {
                AF.upload(multipartFormData: { multipartFormData in
                    multipartFormData
                        .append(query.files, withName: "files", fileName: "postImage.jpeg", mimeType: "image/jpeg")
                }, to: url, headers: headers)
                .responseDecodable(of: ImageUploadModel.self) { response in
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
    
    static func postContent(query: PostQuery) -> Single<PostModel> {
        return Single<PostModel>.create { single in
            do {
                let urlRequest = try PostRouter.postContent(query: query).asURLRequest()
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
