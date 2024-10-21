import Foundation

final class OAuth2Service {
    
    // MARK: - Public Properties
    static let shared = OAuth2Service()
    
    
    // MARK: - Initializers
    private init() {}
    
    
    // MARK: - Public Methods
    static func makeOAuthTokenRequest(code: String) -> URLRequest? {
        
        guard let url = URL(string: Constants.tokenUrl
                            + "?client_id=\(Constants.accessKey)"
                            + "&&client_secret=\(Constants.secretKey)"
                            + "&&redirect_uri=\(Constants.redirectUri)"
                            + "&&code=\(code)"
                            + "&&grant_type=authorization_code")
        else { return nil }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        return urlRequest
    }
    
    
    static func fetchOAuthToken(code: String,
                                handler: @escaping(Result<OAuthTokenResponseBody, Error>) -> ())
    {
        guard let urlRequest = makeOAuthTokenRequest(code: code) else { return }
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let urlSessionTask = urlSession.getData(for: urlRequest) { result in
            switch result {
            case .success(let data):
                do {
                    let oAuthTokenResponseBody = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    handler(.success(oAuthTokenResponseBody))
                }
                catch {
                    print(error.localizedDescription)
                    handler(.failure(error))
                }
            case .failure(let error):
                print(error.localizedDescription)
                handler(.failure(error))
            }
        }
        urlSessionTask.resume()
    }
}
