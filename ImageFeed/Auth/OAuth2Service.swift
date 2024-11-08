import Foundation


enum AuthServerError: Error {
    case invalidRequest
}


final class OAuth2Service {
    
    // MARK: - Public Properties
    static let shared = OAuth2Service()
    
    
    // MARK: - Initializers
    private init() {}
    
    
    // MARK: - Private Properties
    private let jsonDecoder = JSONDecoder()
    private var urlSessionTask: URLSessionTask?
    private var lastCode: String?
    
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
                         handler: @escaping(Swift.Result<OAuthTokenResponseBody, Error>) -> ())
    {
        assert(Thread.isMainThread)
        guard lastCode != code else {
            handler(.failure(AuthServerError.invalidRequest))
            return
        }
        
        urlSessionTask?.cancel()
        lastCode = code
        
        guard let urlRequest = makeOAuthTokenRequest(code: code) else {
            handler(.failure(AuthServerError.invalidRequest))
            return
        }
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let urlSessionTask = urlSession.objectTask(for: urlRequest) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let oAuthTokenResponseBody):
                handler(.success(oAuthTokenResponseBody))
            case .failure(let error):
                print("[fetchOAuthToken]: Error. \(error.localizedDescription)")
                handler(.failure(error))
            }
            self?.urlSessionTask = nil
            self?.lastCode = nil
        }
        self.urlSessionTask = urlSessionTask
        urlSessionTask.resume()
    }
}
