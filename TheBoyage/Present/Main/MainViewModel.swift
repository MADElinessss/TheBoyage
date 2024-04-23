//
//  MainViewModel.swift
//  TheBoyage
//
//  Created by Madeline on 4/19/24.
//

import Alamofire
import Foundation
import RxCocoa
import RxSwift

class MainViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        let posts: Observable<FetchModel>
        let feed: Observable<FetchModel>
    }
    
    func transform(_ input: Input) -> Output {
        let post = fetchMagazine().asObservable()
        let feed = fetchFeed().asObservable()
        return Output(posts: post, feed: feed)
    }
    
    func fetchMagazine() -> Observable<FetchModel> {
        
        let managerQuery = ManagerQuery(limit: "7", product_id: "")
        return FetchPostsNetworkManager.fetchManagers(id: "6625465e438b876b25f8ec1e", query: managerQuery)
            .asObservable()
            .do(onNext: { response in
                // print("response: \(response)")
            }, onError: { error in
                print("Error \(error)")
            })
    }
    
    func fetchFeed() -> Observable<FetchModel> {
        let fetchQuery = FetchPostQuery(limit: "5", product_id: "boyage_general")
        return FetchPostsNetworkManager.fetchPost(query: fetchQuery)
            .asObservable()
            .do(onNext: { response in
                print("🥹response: \(response)")
            }, onError: { error in
                print("🥹Error \(error)")
            })
    }
}
