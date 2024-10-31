# CubeTest
## System Requirements
本專案使用 Xcode 16.0.0 和 Swift 5 開發，deployment target 為 iOS 15.6。

## App 使用說明
三種頁面狀態 
- 無好友畫⾯。   
- 只有好友列表。   
- 好友列表含邀請。   
    
其他  
- 好友列表⽀援下拉更新(重新呼叫request)
- 點擊搜尋框，畫⾯上推至搜尋框置頂至 navigationBar 下⽅
- Unit Test

## System Design
資料取得用 Singleton pattern 處理，UI 的部分採用 MVVM pattern 處理業務邏輯的溝通。

### APIManagerProtocol
```
protocol APIManagerProtocol {
    func request<T: DecodableResponseTargetType>(_ targetType: T,
                                                 useSampleData: Bool,
                                                 completion: @escaping ((Swift.Result<T.Response?, APIError>) -> Void))
}
```
APIManagerProtocol 用來加載 json 資料，具體實作交由實作端處理

```
/// 具體實作
final class APIManager {
    private let apiProviderFactory: APIProviderProtocol

    private init(apiProviderFactory: APIProviderProtocol) {
        self.apiProviderFactory = apiProviderFactory
    }

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()

    static let shared = APIManager(apiProviderFactory: DefaultAPIProviderFactory())
}

extension APIManager: APIManagerProtocol {
    func request<T: DecodableResponseTargetType>(_ targetType: T,
                                                 useSampleData: Bool = false,
                                                 completion: @escaping ((Swift.Result<T.Response?, APIError>) -> Void))
    {
        let provider = apiProviderFactory.createProvider(useSampleData, targetType)
        sendRequest(with: provider, targetType: targetType, completion: completion)
    }
}

extension APIManager {
    private func sendRequest<T: DecodableResponseTargetType>(with provider: MoyaProvider<T>,
                                                             targetType: T,
                                                             completion: @escaping ((Swift.Result<T.Response?, APIError>) -> Void))
    {
        provider.request(targetType) { result in
            switch result {
            case let .success(response):
                self.handleSuccessResponse(response.data, completion: completion)
            case let .failure(error):
                completion(.failure(.moyaError(error)))
            }
        }
    }

    private func handleSuccessResponse<T: Decodable>(_ responseData: Data, completion: @escaping ((Swift.Result<T?, APIError>) -> Void)) {
        do {
            let decodedResponse = try decoder.decode(BaseResponse<T>.self, from: responseData)
            DispatchQueue.main.async {
                completion(.success(decodedResponse.response))
            }
        } catch {
            completion(.failure(APIError.decodeFailed(error)))
        }
    }
}
```
### ConfigUI
```
protocol ConfigUI {
    associatedtype ViewData
    func configure(viewData: ViewData)
}

extension ConfigUI {
    func configure(viewData: ViewData) {}
}
```
Protocol ConfigUI 用來為 view 設定資料，具體實作交由實作端處理
```
/// 具體實作
class UserInfoView: UIView, ConfigUI {
    typealias ViewData = UserInfoViewData

    func configure(viewData: UserInfoViewData) {
    }
}
```
### ImageAsset
ImageAsset 用來存放所有的圖片字串
```
/// 具體實作
enum ImageAsset: String {
    case iconEye = "eye"
    case iconStarFill = "star.fill"
}
```
## 技術選型
- ViewModel 和 functional reactive programming 的部分使用 Combine。  
- 列表使用 DiffableDataSource 與 CompositionalLayout 實作。  
- Third party libraries 採用 Swift Package Manager 管理。  
- 網路層使用 Moya。  
- 刻 UI 使用 Snapkit。  
