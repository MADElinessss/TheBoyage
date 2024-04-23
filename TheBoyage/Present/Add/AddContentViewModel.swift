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
        
        let imageDataSbj = BehaviorSubject<[String]>(value: [])
        
        let imageData = input.imagesPicked
            .flatMap { Observable.from($0) }
            .flatMap { image -> Observable<String> in
                guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                    self.errorMessage.onNext("Failed to convert image to JPEG")
                    return Observable.empty()
                }
                let imageQuery = ImageUploadQuery(files: imageData)
                return PostNetworkManager.imageUpload(query: imageQuery) // <- 결과 잘 받아옴
                    .asObservable()
                    .flatMap { image -> Observable<String> in
                         print("🍀1", image)
                        if let image = image.files?.first {
                            imageDataSbj.onNext([image])
                            print("🍀2", imageDataSbj)
                            return Observable.just(image)
                        }
                        return Observable.empty()
                    }
                    .catchAndReturn("nil")
                    .debug()
            }
            .toArray()
            .asObservable()
            .debug("이미지 데이터로 변환됨")

        let isSaveEnabled = Observable.combineLatest(input.title, input.content, imageData)
            .debug("CombineLatest 확인")
            .map { title, content, _ in
                !title.isEmpty && !content.isEmpty
            }
            .distinctUntilChanged()
            .debug("isSaveEnabled 상태")

        let postResult = input.saveTrigger
            .debug("1")
//            .withLatestFrom(Observable.combineLatest(input.title, input.content, imageDataSbj))
            .withLatestFrom(Observable.combineLatest(input.title, input.content, imageDataSbj))
            .debug("2")
            .flatMapLatest { title, content, image in
                self.postContent(title: title, content: content, files: image)
            }
            .catch { error in
                self.errorMessage.onNext("여행기를 업로드 하는 데에 실패했습니다. 잠시 후 다시 시도해주세요.")
                return Observable.just(false)
            }

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

