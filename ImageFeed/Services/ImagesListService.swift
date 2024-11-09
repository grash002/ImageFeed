import Foundation

class ImagesListService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    var photo: [Photo]?
    var pageNumber:Int = 0
    let perPage = 10
    
    private var urlRequest: URLRequest?
    private var urlSessionTask: URLSessionTask?
    
    func makePhotosNextPageRequest() -> URLRequest? {
        
        guard urlSessionTask == nil,
              let url = URL(string: Constants.defaultBaseURL+"/photos"),
              let token = StorageService.shared.userAccessToken
        else { return nil }
        pageNumber += 1
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue(StorageService.shared.userAccessToken, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("\(pageNumber)", forHTTPHeaderField: "page")
        urlRequest.setValue("\(perPage)", forHTTPHeaderField: "per_page")
        return urlRequest
    }
    
    
    func fetchPhotosNextPage(code: String,
                             handler: @escaping(Swift.Result<PhotosResult, Error>) -> ())
    {
        assert(Thread.isMainThread)
        
        
        guard let urlRequest = makePhotosNextPageRequest() else {
            handler(.failure(ServerError.invalidRequest))
            return
        }
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let urlSessionTask = urlSession.objectTask(for: urlRequest) { (result: Result<PhotosResult, Error>) in
            switch result {
            case .success(let photosResult):
                handler(.success(photosResult))
            case .failure(let error):
                print("[fetchPhotosNextPage]: Error. \(error.localizedDescription)")
                handler(.failure(error))
            }
        }
        self.urlSessionTask = urlSessionTask
        urlSessionTask.resume()
    }
    
}


enum ServerError: Error {
    case invalidRequest
}
