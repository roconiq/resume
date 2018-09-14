
import Foundation
import MapKit

struct SpotResult: Decodable {
    var next: String?
    var spots: [Spot]?
}

extension SpotResult {
    
    private enum CodingKeys: String, CodingKey {
        case next, spots = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.next = try container.decode(String?.self, forKey: .next)
        self.spots = try container.decode([Spot]?.self, forKey: .spots)
    }
}

struct Spot: Codable {
    let id: Int
    let name: String
    let address: String
    let categories: [String]
    let longitude: String
    let latitude: String
    let images: [SpotImage]
    
    var location: CLLocation? {
        guard let lati = Double(latitude), let long = Double(longitude) else { return nil }
        return CLLocation(latitude: lati, longitude: long)
    }
}

extension Spot {

    private enum CodingKeys: String, CodingKey {
        case id, name, address, longitude, latitude, categories, images
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.address = try container.decode(String.self, forKey: .address)
        self.longitude = try container.decode(String.self, forKey: .longitude)
        self.latitude = try container.decode(String.self, forKey: .latitude)
        self.categories = try container.decode([String].self, forKey: .categories)
        self.images = try container.decode([SpotImage].self, forKey: .images)
    }
}

struct SpotImage: Codable {
    let image: String
    let width: Int
    let height: Int
}

extension SpotImage {
    
    private enum CodingKeys: String, CodingKey {
        case image, width = "image_width", height = "image_height"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.image = try container.decode(String.self, forKey: .image)
        self.width = try container.decode(Int.self, forKey: .width)
        self.height = try container.decode(Int.self, forKey: .height)
    }
}

