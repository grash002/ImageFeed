import Foundation

class ImagesListService {
    
    // MARK: - Public Properties
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let shared = ImagesListService()
    var photos: [Photo]?
    var pageNumber:Int = 0
    let perPage = 10
    
    // MARK: - Private Properties
    private var urlRequest: URLRequest?
    private var urlSessionTask: URLSessionTask?
    private var urlSessionTaskChangeLike: URLSessionTask?
    
    
    // MARK: - Initializers
    private init() {}
    
    
    // MARK: - Public methods
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        
        let urlString = "\(Constants.defaultBaseURL)photos/\(photoId)/like"
        guard let url = URL(string: urlString),
              let token = StorageService.shared.userAccessToken
        else { return }
        self.urlSessionTaskChangeLike?.cancel()
        
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
                completion(.failure(error))
            }
        }
        self.urlSessionTaskChangeLike = urlSessionTask
        urlSessionTask.resume()
    }
    
    
    func fetchPhotosNextPage()
    {
        assert(Thread.isMainThread)
        
        guard let urlRequest = makePhotosNextPageRequest() else {
            print(ServerError.invalidRequest.localizedDescription)
            return
        }
        urlSessionTask?.cancel()
        self.photos = []
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let urlSessionTask = urlSession.objectTask(for: urlRequest) { [weak self] (result: Result<PhotosResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(let photosResult):
                self.photos = self.photoResultToPhoto(photosResult)
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                self.urlSessionTask = nil
            case .failure(let error):
                print("[fetchPhotosNextPage]: Error. \(error.localizedDescription)")
            }
        }
        self.urlSessionTask = urlSessionTask
        urlSessionTask.resume()
    }
    
    
    // MARK: - Private methods
    private func photoResultToPhoto(_ photosResult:PhotosResult) -> [Photo] {
        var photos: [Photo] = []
        let formatter = ISO8601DateFormatter()
        
        for photoResult in photosResult {
            let photo = Photo(id: photoResult.id,
                              size: CGSize(width: photoResult.width, height: photoResult.height),
                              createdAt: formatter.date(from: photoResult.createdAt ?? ""),
                              welcomeDescription: photoResult.description,
                              thumbImageURL: photoResult.urls.thumb,
                              largeImageURL: photoResult.urls.full,
                              isLiked: photoResult.likedByUser)
            photos.append(photo)
        }
        return photos
    }
    
    
    private func makePhotosNextPageRequest() -> URLRequest? {
        pageNumber += 1
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
