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

// MARK: - Track
struct Track: Codable {
    let id: Int
    let title: String
    let duration: Int
    let position: Int
    let artist: Artist
    let album: Album

    enum CodingKeys: String, CodingKey {
        case id, title
        case duration
        case position, artist, album
    }
}

// MARK: - Album
struct Album: Codable {
    let id: Int
    let title: String
    let cover: URL
    let coverSmall, coverMedium, coverBig, coverXl: URL
    let tracklist: String

    enum CodingKeys: String, CodingKey {
        case id, title, cover
        case coverSmall = "cover_small"
        case coverMedium = "cover_medium"
        case coverBig = "cover_big"
        case coverXl = "cover_xl"
        case tracklist
    }
}

// MARK: - Artist
struct Artist: Codable {
    let name: String
    let picture: URL
    let pictureSmall, pictureMedium, pictureBig, pictureXl: URL

    enum CodingKeys: String, CodingKey {
        case name, picture
        case pictureSmall = "picture_small"
        case pictureMedium = "picture_medium"
        case pictureBig = "picture_big"
        case pictureXl = "picture_xl"
    }
}
