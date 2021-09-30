// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let chartTracksResponse = try? newJSONDecoder().decode(ChartTracksResponse.self, from: jsonData)

import Foundation

// MARK: - ChartTracksResponse
struct ChartTracksResponse: Codable {
    let data: [Track]
    let total: Int
}

// MARK: - Datum
struct Track: Codable {
    let id: Int
    let title: String
    let duration, rank: Int
    let md5Image: String
    let position: Int
    let artist: Artist
    let album: Album

    enum CodingKeys: String, CodingKey {
        case id, title
        case duration, rank
        case md5Image = "md5_image"
        case position, artist, album
    }
}

// MARK: - Album
struct Album: Codable {
    let id: Int
    let title: String
    let cover: String
    let coverSmall, coverMedium, coverBig, coverXl: String
    let md5Image: String
    let tracklist: String
    let type: AlbumType

    enum CodingKeys: String, CodingKey {
        case id, title, cover
        case coverSmall = "cover_small"
        case coverMedium = "cover_medium"
        case coverBig = "cover_big"
        case coverXl = "cover_xl"
        case md5Image = "md5_image"
        case tracklist, type
    }
}

enum AlbumType: String, Codable {
    case album = "album"
}

// MARK: - Artist
struct Artist: Codable {
    let name: String
    let picture: String
    let pictureSmall, pictureMedium, pictureBig, pictureXl: String

    enum CodingKeys: String, CodingKey {
        case name, picture
        case pictureSmall = "picture_small"
        case pictureMedium = "picture_medium"
        case pictureBig = "picture_big"
        case pictureXl = "picture_xl"
    }
}
