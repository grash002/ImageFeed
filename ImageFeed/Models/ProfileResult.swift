import Foundation

struct ProfileResult: Decodable {
    let userName: String
    let name: String
    let firstName: String
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case name
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}
