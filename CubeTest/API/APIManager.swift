//
//  APIManager.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//

import Foundation
import Moya

protocol APIManagerProtocol {
    func request<T: DecodableResponseTargetType>(_ targetType: T,
                                                 useSampleData: Bool,
                                                 completion: @escaping ((Swift.Result<T.Response?, APIError>) -> Void))
}

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
