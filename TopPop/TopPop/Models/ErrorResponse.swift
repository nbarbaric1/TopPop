import Foundation

// MARK: - ErrorResponse
struct ErrorResponse: Codable {
    let error: Error
}

// MARK: - Error
struct Error: Codable {
    let type, message: String
    let code: Int
}
