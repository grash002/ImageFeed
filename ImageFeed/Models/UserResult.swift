import Foundation

struct UserResult: Decodable {
    let userName: String
    let name: String
    let profileImage: ProfileImage
    let profileLinks: ProfileLinks
    
    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case name
        case profileImage = "profile_image"
        case profileLinks = "links"
    }
}
