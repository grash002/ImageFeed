import Foundation

final class OAuth2Service {
    
    // MARK: - Public Properties
    static let shared = OAuth2Service()
    
    
    // MARK: - Initializers
    private init() {}
    private let jsonDecoder = JSONDecoder()
    
    // MARK: - Public Methods
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        
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
    
    
    func fetchOAuthToken(code: String,
                         handler: @escaping(Swift.Result<String, Error>) -> ())
    {
        guard let urlRequest = makeOAuthTokenRequest(code: code) else { return }
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let urlSessionTask = urlSession.getData(for: urlRequest) { result in
            switch result {
            case .success(let data):
                let response = String(data: data, encoding: .utf8) ?? ""
                handler(.success(response))
            case .failure(let error):
                print(error.localizedDescription)
                handler(.failure(error))
            }
        }
        urlSessionTask.resume()
    }
}
