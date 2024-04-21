//
//  MyProfileNetworkManager.swift
//  TheBoyage
//
//  Created by Madeline on 4/21/24.
//

import Alamofire
import Foundation
import RxSwift

struct MyProfileNetworkManager {
    static func fetchMyProfile() -> Single<MyProfileModel> {
        return Single<MyProfileModel>.create { single in
            do {
                let urlRequest = try MyPageRouter.profile.asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: MyProfileModel.self) { response in
                        print("🍀 myprofile manager", response.response?.statusCode)
                        print(response)
                        switch response.result {
                        case .success(let profile):
                            single(.success(profile))
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