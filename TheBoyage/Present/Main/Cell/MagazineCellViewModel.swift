//
//  MagazineCellViewModel.swift
//  TheBoyage
//
//  Created by Madeline on 4/20/24.
//

import Foundation
import Kingfisher
import RxSwift
import RxCocoa
import UIKit

class MagazineCellViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let post: Posts
    }
    
    struct Output {
        let title: Observable<String?>
        let image: Observable<UIImage>
    }
    
    func transform(_ input: Input) -> Output {
        let title = Observable.just(input.post.title)
        let image = ImageService.shared.loadImage(from: input.post.files.first)
        return Output(title: title, image: image)
    }

}
