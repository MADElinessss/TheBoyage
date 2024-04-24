//
//  AddContentViewModel.swift
//  TheBoyage
//
//  Created by Madeline on 4/16/24.
//

import Alamofire
import Foundation
import RxCocoa
import RxSwift
import UIKit
import PhotosUI

class AddContentViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let title: Observable<String>
        let content: Observable<String>
        let imagesPicked: Observable<[UIImage]>
        let saveTrigger: Observable<Void>
    }
    
    struct Output {
        let isSaveEnabled: Observable<Bool>
        let postResult: Observable<Bool>
        let errorMessage: Observable<String?>
    }
    
    let errorMessage = PublishSubject<String?>()
    
    func transform(_ input: Input) -> Output {
        
        let isSaveEnabled = Observable.combineLatest(input.title, input.content)
            .map { title, content in
                !title.isEmpty && !content.isEmpty
            }
            .distinctUntilChanged()
        
        let postResult = input.saveTrigger
            .withLatestFrom(Observable.combineLatest(input.title, input.content, input.imagesPicked))
            .flatMapLatest { title, content, images in
                self.uploadImages(images)
                    .flatMap { imageUrls -> Observable<Bool> in
                        self.postContent(title: title, content: content, files: imageUrls)
                    }
            }
            .catch { error in
                self.errorMessage.onNext("여행기를 업로드 하는 데에 실패했습니다. 잠시 후 다시 시도해주세요.")
                return Observable.just(false)
            }
        
        return Output(isSaveEnabled: isSaveEnabled, postResult: postResult, errorMessage: errorMessage.asObservable())
    }
    
    private func uploadImages(_ images: [UIImage]) -> Observable<[String]> {
        return Observable.from(images) // 이미지 배열에서 Observable 생성
            .flatMap { image -> Observable<String> in // 각 이미지에 대해 실행
                guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                    self.errorMessage.onNext("JPEG로 변환 실패")
                    return Observable.empty()
                }
                let imageQuery = ImageUploadQuery(files: imageData)
                return PostNetworkManager.imageUpload(query: imageQuery)
                    .asObservable()
                    .map { uploadResult -> String in
                        guard let uploadedImageUrl = uploadResult.files.first else {
                            throw NSError(domain: "ImageUploadError", code: 0, userInfo: [NSLocalizedDescriptionKey: "이미지 업로드 실패"])
                        }
                        return uploadedImageUrl
                    }
            }
            .toArray() // String -> [String]
            .asObservable() // Single -> Observable
    }
    
    private func postContent(title: String, content: String, files: [String]) -> Observable<Bool> {
        let query = PostQuery(title: title, content: content, content1: "#manager", product_id: "boyage_general", files: files)
        return PostNetworkManager.postContent(query: query)
            .asObservable()
            .map { _ in true }
            .catch { error in
                self.errorMessage.onNext("게시글 업로드 실패: \(error.localizedDescription)")
                return Observable.just(false)
            }
    }
}
