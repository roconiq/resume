
import Foundation
import Moya

enum SpotService {
    case fetchSpotList
}

extension SpotService: Moya.TargetType {
    
    var baseURL: URL {
        return URL(string: API_URL)!
    }
    
    var path: String {
        switch self {
        case .getSpotList:
            return "places/seoul/spots"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getSpotList:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .getSpotList:
            return .requestPlain
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
}

