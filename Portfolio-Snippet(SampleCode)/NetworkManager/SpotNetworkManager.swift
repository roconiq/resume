

import Foundation
import Moya

typealias spotCompletionHandler = (SpotResult?, Error?) -> ()

struct SpotNetworkManager: SpotNetworkable {
    var provider: MoyaProvider<SpotService> = MoyaProvider<SpotService>(manager: SnippetAlamofireManager.sharedManager)
}

protocol SpotNetworkable: Networkable {
    var provider: MoyaProvider<SpotService> { get set }
    
    func fetchSpotList(completion: @escaping spotCompletionHandler)
}

extension SpotNetworkable {
    
    func fetchSpotList(completion: @escaping spotCompletionHandler) {
        provider.request(.fetchSpotList) { result in
            switch result {
            case .success(let response):
                do {
                    let spots = try JSONDecoder().decode(SpotResult.self, from: response.data)
                    completion(spots, nil)
                } catch _ {
                    fatalError(ParsingErrorMsg)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
