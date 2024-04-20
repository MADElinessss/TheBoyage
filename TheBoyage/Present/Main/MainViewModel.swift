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
    }
    
    func transform(_ input: Input) -> Output {
        let post = fetchMagazine().asObservable()
        return Output(posts: post)
    }
    
    func fetchMagazine() -> Observable<FetchModel>{
        
        let managerQuery = ManagerQuery(limit: "7", product_id: "")
        return FetchPostsNetworkManager.fetchManagers(id: "662203c7e8473868acf6ebff", query: managerQuery)
            .asObservable()
    }
}
