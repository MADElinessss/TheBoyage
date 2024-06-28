# 🛩️ 여행 매거진, THE BOYAGE

## 프로젝트
- iOS 1인개발, 기획, 디자인
- 개발기간: 4/10 ~ 4/29 (2.5주)
- Configuration: 최소버전 15.0 / 세로 모드 / 라이트모드 / iOS

### 기술 스택

(v1.0.1) 기준
- UIKit / RxSwift
- MVVM / Router / Alamofire / Kingfisher / Codable
- CodeBasedUI / SnapKit / CompositionalLayout / CollectionViewPagingLayout

### Alamofire Request 추상화
```swift
struct NetworkService {
    static func performRequest<T: Decodable>(route: URLRequestConvertible, responseType: T.Type, completion: @escaping (T) -> Void) -> Single<T> {
        return Single<T>.create { single in
            do {
                let urlRequest = try route.asURLRequest()
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: responseType) { response in
                        switch response.result {
                        case .success(let value):
                            completion(value)
                            single(.success(value))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
}
```

## Screenshots
<table>
<tr>
<td>
  
![Simulator Screenshot - iPhone 15 Pro - 2024-05-04 at 15 54 45](https://github.com/MADElinessss/TheBoyage/assets/88757043/6aa90836-7737-42c9-be42-f1d05f7e81a2)
    

</td>
<td>

![Simulator Screenshot - iPhone 15 Pro - 2024-05-04 at 15 54 48](https://github.com/MADElinessss/TheBoyage/assets/88757043/eba07a90-ed0b-41d7-9645-02e306440803)


</td>
<td>

![Simulator Screenshot - iPhone 15 Pro - 2024-05-04 at 15 54 58](https://github.com/MADElinessss/TheBoyage/assets/88757043/8bcc1b75-79ad-49da-b6df-151f97c21ee9)


</td>
<td>

![Simulator Screenshot - iPhone 15 Pro - 2024-05-04 at 15 54 51](https://github.com/MADElinessss/TheBoyage/assets/88757043/907e6f96-6fbe-4a2e-a51b-8ddb51d52238)


</td>
</tr>
</table>


<table>
<tr>
<td>

![Simulator Screenshot - iPhone 15 Pro - 2024-05-04 at 15 55 05](https://github.com/MADElinessss/TheBoyage/assets/88757043/29decbbd-4d86-4796-bdb3-4af8faa55bac)


</td>
<td>

![Simulator Screenshot - iPhone 15 Pro - 2024-05-04 at 15 55 10](https://github.com/MADElinessss/TheBoyage/assets/88757043/dcb5e111-2e84-46ae-a6f9-0079c5ec60f3)


</td>
<td>

![Simulator Screenshot - iPhone 15 Pro - 2024-05-04 at 15 55 13](https://github.com/MADElinessss/TheBoyage/assets/88757043/aa8aaaa7-7603-4231-944c-493614871150)


</td>
<td>

![Simulator Screenshot - iPhone 15 Pro - 2024-05-04 at 15 55 19](https://github.com/MADElinessss/TheBoyage/assets/88757043/05b1fbfe-eb22-4d19-aa0c-b4631826a7b3)


</td>
</tr>
</table>

<table>
<tr>
<td>

![Simulator Screenshot - iPhone 15 Pro - 2024-05-04 at 15 55 29](https://github.com/MADElinessss/TheBoyage/assets/88757043/d6443714-5231-40d5-8f6c-b1f732f0fc37)


</td>
<td>

![Simulator Screenshot - iPhone 15 Pro - 2024-05-04 at 15 55 32](https://github.com/MADElinessss/TheBoyage/assets/88757043/6c923266-ac21-4e6a-aeed-5cca91de96a5)


</td>
<td>

![Simulator Screenshot - iPhone 15 Pro - 2024-05-04 at 15 55 35](https://github.com/MADElinessss/TheBoyage/assets/88757043/219d35a5-5a66-425a-9519-02601b3b1617)


</td>
<td>


![Simulator Screenshot - iPhone 15 Pro - 2024-05-04 at 15 55 42](https://github.com/MADElinessss/TheBoyage/assets/88757043/579dc101-90b1-4a35-bbdb-3079404a352e)


</td>
</tr>
</table>
