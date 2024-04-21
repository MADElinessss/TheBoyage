//
//  EditProfileViewModel\.swift
//  TheBoyage
//
//  Created by Madeline on 4/22/24.
//

import Foundation
import RxSwift
import RxCocoa
import PhotosUI

class EditProfileViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    struct Input {
        let imageSelected: PublishSubject<UIImage>
    }
    
    struct Output {
        let selectedImage: Driver<UIImage?>
    }
    
    private let selectedImageSubject = BehaviorSubject<UIImage?>(value: nil)
    
    func transform(_ input: Input) -> Output {
        // 외부에서 받은 이미지 -> Subject
        input.imageSelected
            .bind(to: selectedImageSubject)
            .disposed(by: disposeBag)
        
        // BehaviorSubject -> Driver
        let selectedImage = selectedImageSubject
            .asDriver(onErrorJustReturn: nil)
        
        return Output(selectedImage: selectedImage)
    }
}
