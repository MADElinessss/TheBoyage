//
//  ImageService.swift
//  TheBoyage
//
//  Created by Madeline on 4/28/24.
//

import Alamofire
import Kingfisher
import RxCocoa
import RxSwift
import UIKit

class ImageService {
    static let shared = ImageService()
    
    private init() {}
    
    func loadImage(from imageName: String?) -> Observable<UIImage> {
        guard let imageName = imageName,
              let url = URL(string: APIKey.baseURL.rawValue + "/v1/" + imageName) else {
            return .just(UIImage(systemName: "airplane.departure")!)
        }
        
        return Observable<UIImage>.create { observer in
            let header = AnyModifier { request in
                var request = request
                request.setValue(UserDefaults.standard.string(forKey: "AccessToken") ?? "", forHTTPHeaderField: HTTPHeader.authorization.rawValue)
                request.setValue(APIKey.sesacKey.rawValue, forHTTPHeaderField: HTTPHeader.sesacKey.rawValue)
                return request
            }
            
            KingfisherManager.shared.retrieveImage(
                with: .network(url),
                options: [.requestModifier(header)],
                completionHandler: { result in
                    switch result {
                    case .success(let value):
                        observer.onNext(value.image)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            )
            
            return Disposables.create()
        }
    }
    
}
