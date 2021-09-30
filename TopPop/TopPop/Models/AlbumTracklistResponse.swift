import Foundation

// MARK: - AlbumTracklistResponse
struct AlbumTracklistResponse: Codable {
    let data: [Track2]
    let total: Int
}

struct Track2: Codable {
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case title
    }
}

