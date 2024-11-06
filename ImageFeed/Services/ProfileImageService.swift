import Foundation
import UIKit

final class ProfileImageService {
    
    // MARK: - Public Properties
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    
    // MARK: - Private Properties
    private (set) var avatarURL: URL?
    private var urlSessionTask: URLSessionTask?
    
    
    // MARK: - Initializers
    private init() {}
    
    
    // MARK: - Public methods
    func fetchProfileImageURL(username: String) {
        guard   let url = URL(string: "\(Constants.defaultBaseURL)/users/\(username)"),
                let token = StorageService.shared.userAccessToken else { return }
        
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "GET"
        
        let urlSession = URLSession.shared
        let urlSessionTask = urlSession.objectTask(for: urlRequest) {[weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let userResult):
                self.avatarURL = URL(string: userResult.profileImage.large)
                self.urlSessionTask?.cancel()
            case .failure(let error):
                print("[fetchProfileImageURL]: Error. \(error.localizedDescription)")
            }
        }
        self.urlSessionTask = urlSessionTask
        urlSessionTask.resume()
    }
    
}


// MARK: - Structs
struct ProfileImage: Decodable {
    let small: String
    let medium: String
    let large: String
}

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