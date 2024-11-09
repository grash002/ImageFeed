import Foundation

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: Date?
    let likes: Int
    let likedByUser: Bool
    let description: String
    let urls: PhotoUrl
    
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case createdAt = "created_at"
        case likes = "username"
        case likedByUser = "liked_by_user"
        case description
        case urls
    }
}

typealias PhotosResult = [PhotoResult]
