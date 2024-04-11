//
//  ViewModelType.swift
//  TheBoyage
//
//  Created by Madeline on 4/11/24.
//

import Foundation
import RxSwift

protocol ViewModelType {
    
    var disposeBag: DisposeBag { get }
    
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
