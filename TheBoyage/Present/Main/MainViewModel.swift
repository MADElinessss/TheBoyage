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
        
    }
    
    func transform(_ input: Input) -> Output {
        return Output()
    }
    
    func fetchMagazine() {
        let managerQuery = ManagerQuery(limit: "7", product_id: "")
        FetchPostsNetworkManager.fetchManagers(id: "662203c7e8473868acf6ebff", query: managerQuery)
            .asObservable()
            .subscribe(with: self) { owner, posts in
                print("viewmodel result = ",posts)
                print("title=", posts.title)
            }
            .disposed(by: disposeBag)
    }
}
