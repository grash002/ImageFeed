import Foundation

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    
    private var imagesListService = ImagesListService.shared
    private var imagesListServiceObserver = NotificationCenter.default
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    func viewDidLoad() {
        imagesListService.fetchPhotosNextPage()
        
        imagesListServiceObserver
            .addObserver(forName: ImagesListService.didChangeNotification,
                         object: nil,
                         queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                if self.view?.photos[0].id == self.view?.mockPhoto?.id {
                    self.view?.photos = []
                    self.view?.tableView.reloadData()
                }
                self.view?.photos = imagesListService.photos
                self.updateTableViewAnimated()
            }
        
        imagesListServiceObserver
            .addObserver(forName: ImagesListCell.likeDidChangeNotification,
                         object: nil,
                         queue: .main
            ) { [weak self] notification in
                guard let self = self else { return }
                UIBlockingProgressHUD.show()
                if let imageId = notification.userInfo?["imageId"] as? String,
                   let isLike = notification.userInfo?["isLike"] as? Bool{
                    imagesListService.changeLike(photoId: imageId,
                                                 isLike: isLike) {[weak self] result in
                        guard let self else { return }
                        switch result {
                        case .success(()):
                            self.changeLikeImage(imageId: imageId, isLike: isLike)
                            UIBlockingProgressHUD.dismiss()
                        case.failure(let error):
                            print("[changeLike] error. \(error.localizedDescription)")
                            UIBlockingProgressHUD.dismiss()
                        }
                    }
                }
            }
    }
    
    
    func cellDidTap(indexPath: IndexPath) {
        let singleImageViewController = SingleImageViewController()
        
        singleImageViewController.imageUrl = view?.photos[indexPath.row].largeImageURL
        singleImageViewController.modalPresentationStyle = .fullScreen
        view?.present(singleImageViewController, animated: true)
    }
    
    
    func changeLikeImage(imageId: String, isLike: Bool) {
        if let index = view?.photos.firstIndex(where: { $0.id == imageId}),
           let photo = view?.photos[index]{
            let newPhoto = Photo(
                id: photo.id,
                size: photo.size,
                createdAt: photo.createdAt,
                welcomeDescription: photo.welcomeDescription,
                thumbImageURL: photo.thumbImageURL,
                largeImageURL: photo.largeImageURL,
                isLiked: isLike
            )
            view?.photos[index] = newPhoto
        }
    }
    
    
    func updateTableViewAnimated() {
        let oldCount = (view?.photos.count ?? 0) - imagesListService.perPage
        let newCount = oldCount + imagesListService.perPage
        
        if oldCount >= 0 {
            view?.updateTableViewAnimated(fromIndex: oldCount, toIndex: newCount)
        }
    }
    
    func fetchPhotosNextPage () {
        imagesListService.fetchPhotosNextPage()
    }
    
}
