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
    }
    
    func transform(_ input: Input) -> Output {
        let imageData = input.imagesPicked
            .map { images in
                images.compactMap { $0.jpegData(compressionQuality: 0.8) }
            }
        let isSaveEnabled = Observable.combineLatest(input.title, input.content)
            .map { title, content in
                !title.isEmpty && !content.isEmpty
            }
            .distinctUntilChanged()
        
        // 게시글 저장
        let postResult = input.saveTrigger
            .withLatestFrom(Observable.combineLatest(input.title, input.content, imageData))
            .flatMapLatest { title, content, imagesData in
                self.postContent(title: title, content: content, imagesData: imagesData)
            }
        
        return Output(isSaveEnabled: isSaveEnabled, postResult: postResult)
    }
    
    private func loadImages(from results: [PHPickerResult]) -> Observable<[Data]> {
        let loadImages = results.map { result -> Observable<Data> in
            Observable<Data>.create { observer in
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                        DispatchQueue.main.async {
                            if let error = error {
                                observer.onError(error)
                                return
                            }
                            if let image = image as? UIImage, let imageData = image.jpegData(compressionQuality: 0.8) {
                                observer.onNext(imageData)
                                observer.onCompleted()
                            } else {
                                observer.onError(NSError(domain: "AddContentViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"]))
                            }
                        }
                    }
                } else {
                    observer.onError(NSError(domain: "AddContentViewModel", code: -2, userInfo: [NSLocalizedDescriptionKey: "Cannot load image"]))
                }
                return Disposables.create()
            }
        }
        return Observable.zip(loadImages)
    }
    
    private func postContent(title: String, content: String, imagesData: [Data]) -> Observable<Bool> {
        let files = imagesData.map { data -> String in
            return "fileNameFromData"
        }
        
        let query = PostQuery(title: title, content: content, content1: "#manager", product_id: "boyage_general", files: files)
        return PostNetworkManager.postContent(query: query)
            .asObservable()
            .do(onNext: { response in
                print(response)
            }, onError: { error in
                print("Failed to post content:", error)
            })
            .map { response -> Bool in
                return true
            }
    }
}

