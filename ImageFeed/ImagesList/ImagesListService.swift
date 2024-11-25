import Foundation

final class ImagesListService {
    
    // MARK: - Public Properties
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let shared = ImagesListService()
    var photos: [Photo] = []
    var pageNumber:Int = 0
    let perPage = 10
    
    // MARK: - Private Properties
    private var urlRequest: URLRequest?
    private var urlSessionTask: URLSessionTask?
    private var urlSessionTaskChangeLike: URLSessionTask?
    static private let formatter = ISO8601DateFormatter()
    
    
    // MARK: - Initializers
    private init() {}
    
    
    // MARK: - Public methods
    func resetService() {
        photos = []
        pageNumber = 0
    }
    
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        
        let urlString = "\(Constants.defaultBaseURL)photos/\(photoId)/like"
        guard let url = URL(string: urlString),
              let token = StorageService.shared.userAccessToken
        else { return }
    
        if self.urlSessionTaskChangeLike != nil {
            print("[changeLike] - Request rejected, last request not yet completed")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        
        urlRequest.httpMethod = isLike ?  "POST" : "DELETE"
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let urlSessionTask = urlSession.objectTask(for: urlRequest) { [weak self] (result: Result<PhotoLikeResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(_):
                self.urlSessionTaskChangeLike = nil
                completion(.success(()))
            case .failure(let error):
                self.urlSessionTaskChangeLike = nil
                completion(.failure(error))
            }
        }
        self.urlSessionTaskChangeLike = urlSessionTask
        urlSessionTask.resume()
    }
    
    
    func fetchPhotosNextPage()
    {
        assert(Thread.isMainThread)
        
        guard let urlRequest = makePhotosNextPageRequest()
        else {
            print(ServerError.invalidRequest.localizedDescription)
            return
        }
        
        if self.urlSessionTask != nil {
            print("[fetchPhotosNextPage]. Request rejected, last request not yet completed")
            return
        }
        
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let urlSessionTask = urlSession.objectTask(for: urlRequest) { [weak self] (result: Result<PhotosResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(let photosResult):
                self.pageNumber += 1
                self.photos.append(contentsOf: self.photoResultToPhoto(photosResult))
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                self.urlSessionTask = nil
            case .failure(let error):
                print("[fetchPhotosNextPage]: Error. \(error.localizedDescription)")
                self.urlSessionTask = nil
            }
        }
        self.urlSessionTask = urlSessionTask
        urlSessionTask.resume()
    }
    
    
    // MARK: - Private methods
    private func photoResultToPhoto(_ photosResult:PhotosResult) -> [Photo] {
        var photos: [Photo] = []
        
        for photoResult in photosResult {
            let photo = Photo(id: photoResult.id,
                              size: CGSize(width: photoResult.width, height: photoResult.height),
                              createdAt: photoResult.createdAt.flatMap { ImagesListService.formatter.date(from:  $0) },
                              welcomeDescription: photoResult.description,
                              thumbImageURL: URL(string: photoResult.urls.thumb),
                              largeImageURL: URL(string: photoResult.urls.full),
                              isLiked: photoResult.likedByUser)
            photos.append(photo)
        }
        return photos
    }
    
    
    private func makePhotosNextPageRequest() -> URLRequest? {
        let pageNumber = self.pageNumber + 1
        let urlString = "\(Constants.defaultBaseURL)photos?page=\(pageNumber)&per_page=\(perPage)"
        
        guard let url = URL(string: urlString),
              let token = StorageService.shared.userAccessToken
        else { return nil }
        
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}


enum ServerError: Error {
    case invalidRequest
}
