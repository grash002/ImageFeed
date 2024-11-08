import Foundation

struct ProfileLinks: Decodable {
    let selfLink: String
    let htmlLink: String
    let photos: String
    let likes: String
    let portfolio: String
    
    enum CodingKeys: String, CodingKey {
        case selfLink = "self"
        case htmlLink = "html"
        case photos
        case likes
        case portfolio
    }
}
