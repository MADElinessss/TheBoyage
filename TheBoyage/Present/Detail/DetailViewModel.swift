//
//  DetailViewModel.swift
//  TheBoyage
//
//  Created by Madeline on 4/28/24.
//

import Foundation
import UIKit
import RxSwift

class DetailViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    struct Input {
        let post: Posts
    }
    
    struct Output {
        let image: Observable<UIImage>
    }
    
    func transform(_ input: Input) -> Output {
        let image = ImageService.shared.loadImage(from: input.post.files.first)
        return Output(image: image)
    }
}
