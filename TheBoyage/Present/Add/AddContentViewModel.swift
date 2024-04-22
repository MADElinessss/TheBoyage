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
        let imageData = input.imagesPicked
            .flatMap { Observable.from($0) }
            .flatMap { image -> Observable<String> in
                guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                    self.errorMessage.onNext("Failed to convert image to JPEG")
                    return Observable.empty()
                }
                let imageQuery = ImageUploadQuery(files: imageData)
                return PostNetworkManager.imageUpload(query: imageQuery)
                    .asObservable()
                    .flatMap { imageUploadModel -> Observable<String> in
                        guard let fileUrl = imageUploadModel.files?.first else {
                            self.errorMessage.onNext("Image upload failed")
                            return Observable.empty()
                        }
                        return Observable.just(fileUrl)
                    }
                    .catchAndReturn("Upload failed")
            }
            .toArray()
            .asObservable()
            .debug("이미지 데이터로 변환됨")

        let isSaveEnabled = Observable.combineLatest(input.title, input.content)
            .debug("CombineLatest 확인")
            .map { title, content in
                !title.isEmpty && !content.isEmpty
            }
            .distinctUntilChanged()
            .debug("isSaveEnabled 상태")
        
        // 게시글 저장
        let postResult = Observable.combineLatest(input.saveTrigger, input.title, input.content, imageData.startWith([]))
            .filter { _, title, content, imageData in !imageData.isEmpty }
            .flatMapLatest { _, title, content, imageData in
                self.postContent(title: title, content: content, files: imageData)
            }
            .catch { error in
                self.errorMessage.onNext("여행기를 업로드 하는 데에 실패했습니다. 잠시 후 다시 시도해주세요.")
                return Observable.just(false)
            }
            .debug("Post submission triggered")



        return Output(isSaveEnabled: isSaveEnabled, postResult: postResult, errorMessage: errorMessage.asObservable())
    }
    
    func postContent(title: String, content: String, files: [String]) -> Observable<Bool> {
        let query = PostQuery(title: title, content: content, content1: "#manager", product_id: "boyage_general", files: files)
        return PostNetworkManager.postContent(query: query)
            .asObservable()
            .do(onNext: { response in
                print("Response received:", response)
            }, onError: { error in
                print("Failed to post content:", error)
            })
            .map { response -> Bool in
                true
            }
            .debug("Network request completed")
    }
}

