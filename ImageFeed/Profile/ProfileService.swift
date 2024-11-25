import Foundation
import UIKit


final class ProfileService {
    
    
    // MARK: - Public Properties
    static let shared = ProfileService()
    var profile: Profile?
    var imageProfile: UIImage?
    
    // MARK: - Private Properties
    private var urlSessionTask: URLSessionTask?
    
    
    // MARK: - Initializers
    private init() {}
    
    
    // MARK: - Public methods
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void){
        
        guard let urlRequest = makeProfileRequest(token: token) else {
            completion(.failure(ProfileServerError.invalidRequest))
            return
        }
        
        if
            self.urlSessionTask != nil {
            self.urlSessionTask?.cancel()
        }
        
        let urlSession = URLSession.shared
        let urlSessionTask = urlSession.objectTask(for: urlRequest){ [weak self] (result: Result<ProfileResult, Error>) in
            
            guard let self = self else { return }
            switch result {
            case .success(let profileResult):
                
                    let profile = Profile(userName: profileResult.userName,
                                          name: profileResult.name,
                                          loginName: "@\(profileResult.userName)",
                                          bio: profileResult.bio ?? "")
                    completion(.success(profile))
                    self.urlSessionTask = nil
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.urlSessionTask = urlSessionTask
        urlSessionTask.resume()
    }
    
    
    
    private func makeProfileRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "\(Constants.defaultBaseURL)/me") else
        { return nil }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "GET"
        return urlRequest
    }
}


// MARK: - Structs

enum ProfileServerError: Error {
    case invalidRequest
}
