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
import UIKit

class MainViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    let nextCursor = BehaviorSubject<String?>(value: nil)
    
    struct Input {
        
    }
    
    struct Output {
        let posts: Observable<FetchModel>
        let feed: Observable<FetchModel>
        let requireLogin: Observable<Bool>
    }
    
    let loginRequired = PublishSubject<Bool>()
    
    func transform(_ input: Input) -> Output {
        let post = fetchMagazine().asObservable()
        let feed = fetchFeed().asObservable()
        
        feed.subscribe(onError: { error in
                if let afError = error as? AFError, afError.isResponseSerializationError {
                    self.loginRequired.onNext(true)
                }
            }).disposed(by: disposeBag)
        
        return Output(posts: post, feed: feed, requireLogin: loginRequired.asObservable())
    }
    
    func fetchMagazine() -> Observable<FetchModel> {
        
        let managerQuery = ManagerQuery(limit: "5", product_id: "")
        return FetchPostsNetworkManager.fetchSpecificUser(id: "6625465e438b876b25f8ec1e", query: managerQuery)
            .asObservable()
            .do(onNext: { response in
                
            }, onError: { error in
                print("🥹magazine Error \(String(describing: error.asAFError))")
                if let afError = error as? AFError, afError.isResponseSerializationError {
                    if let statusCode = afError.responseCode {
                        switch statusCode {
                        case 403, 419:
                            self.loginRequired.onNext(true)
                        default:
                            break
                        }
                    }
                }
            })
    }
    
    func fetchFeed() -> Observable<FetchModel> {
        let fetchQuery = FetchPostQuery(limit: "3", product_id: "boyage_general", next: nil)
        return FetchPostsNetworkManager.fetchPostWithRetry(query: fetchQuery)
            .asObservable()
            .do(onNext: { response in
                print("🥹response: \(response)")
                if let newCursor = response.next_cursor {
                    self.nextCursor.onNext(newCursor)
                    print("다음 값 있음")
                } else {
                    self.nextCursor.onNext(nil)
                    print("다음 값 없음")
                }
            }, onError: { [weak self] error in
                print("🥹feed Error \(error.localizedDescription)")
                if let afError = error as? AFError, afError.isResponseSerializationError {
                    
                    if let statusCode = afError.responseCode {
                        print("-------- error \(statusCode)------------")
                        switch statusCode {
                        case 403, 419:  // 토큰 만료
                            self?.loginRequired.onNext(true)
                        default:
                            break
                        }
                    }       
                }
            })
    }
}
