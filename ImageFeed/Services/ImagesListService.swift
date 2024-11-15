import Foundation

class ImagesListService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    var photos: [Photo]?
    var pageNumber:Int = 0
    let perPage = 10
    
    private var urlRequest: URLRequest?
    private var urlSessionTask: URLSessionTask?
    
    private func makePhotosNextPageRequest() -> URLRequest? {
        
        guard let url = URL(string: Constants.defaultBaseURL+"photos"),
              let token = StorageService.shared.userAccessToken
        else { return nil }
        pageNumber += 1
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("\(pageNumber)", forHTTPHeaderField: "page")
        urlRequest.setValue("\(perPage)", forHTTPHeaderField: "per_page")
        return urlRequest
    }

    
    func fetchPhotosNextPage()
    {
        assert(Thread.isMainThread)
        
        guard let urlRequest = makePhotosNextPageRequest() else {
            assertionFailure(ServerError.invalidRequest.localizedDescription)
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
            case .failure(let error):
                print("[fetchPhotosNextPage]: Error. \(error.localizedDescription)")
            }
        }
        self.urlSessionTask = urlSessionTask
        urlSessionTask.resume()
    }
    
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
    
}


enum ServerError: Error {
    case invalidRequest
}
