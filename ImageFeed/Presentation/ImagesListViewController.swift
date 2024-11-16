import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var imagesListServiceObserver = NotificationCenter.default
    private let currentDate = Date()
    private var animationLayers = Set<CALayer>()
    
    private var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private lazy var mockPhoto: Photo = {
        Photo(id: "MockPhoto",
              size: CGSize(width: 343, height: 252),
              createdAt: Date(),
              welcomeDescription: "",
              thumbImageURL: "",
              largeImageURL: "",
              isLiked: false)
    }()
    private lazy var mockBigPhoto: Photo = {
        Photo(id: "MockPhoto",
              size: CGSize(width: 343, height: 370),
              createdAt: Date(),
              welcomeDescription: "",
              thumbImageURL: "",
              largeImageURL: "",
              isLiked: false)
    }()
    
    
    private var tableView = UITableView()
    
    
    // MARK: - Lifecycle
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        imagesListServiceObserver.removeObserver(self, name: ImagesListService.didChangeNotification, object: nil)
        imagesListServiceObserver.removeObserver(self, name: ImagesListCell.likeDidChangeNotification, object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setImagesListView()
        imagesListService.fetchPhotosNextPage()
        
        imagesListServiceObserver
            .addObserver(forName: ImagesListService.didChangeNotification,
                         object: nil,
                         queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                if self.photos[0].id == mockPhoto.id {
                    self.photos = []
                    self.tableView.reloadData()
                }
                self.photos.append(contentsOf: imagesListService.photos ?? [])
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
    
    
    // MARK: - Private methods
    private func addAnimateGradient(to imageView: UIImageView, withSize size: CGSize) -> CAGradientLayer {
        
        let gradientImage = configGradient(cornerRadius: 
                                            imageView.layer.cornerRadius,
                                           size: size)
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        
        [gradientImage].forEach {
            $0.add(gradientChangeAnimation, forKey: "locationsChange")
            animationLayers.insert($0)
        }
        
        imageView.layer.addSublayer(gradientImage)
        return gradientImage
    }
    
    
    private func configGradient(cornerRadius: CGFloat, size: CGSize) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: .zero, size: size)
        gradient.cornerRadius = cornerRadius
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.masksToBounds = true
        return gradient
    }
    
    
    private func changeLikeImage(imageId: String, isLike: Bool) {
        if let index = self.photos.firstIndex(where: { $0.id == imageId}) {
            let photo = self.photos[index]
            let newPhoto = Photo(
                     id: photo.id,
                     size: photo.size,
                     createdAt: photo.createdAt,
                     welcomeDescription: photo.welcomeDescription,
                     thumbImageURL: photo.thumbImageURL,
                     largeImageURL: photo.largeImageURL,
                     isLiked: isLike
                 )
            self.photos[index] = newPhoto
        }
    }
    
    
    private func switchToSingleImageView(indexPath: IndexPath) {
        let singleImageViewController = SingleImageViewController()
        
        guard let url = URL(string: photos[indexPath.row].largeImageURL) else {
            return
        }
        singleImageViewController.imageUrl = url
        singleImageViewController.modalPresentationStyle = .fullScreen
        present(singleImageViewController, animated: true)
    }
    
    
    private func setImagesListView() {
        view.backgroundColor = UIColor(named: "YPBlack")
        photos.append(contentsOf: [mockPhoto,
                                   mockBigPhoto,
                                   mockPhoto])
        
        
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        
        tableView.backgroundColor = UIColor(named: "YPBlack")
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12,
                                              left: 0,
                                              bottom: 0,
                                              right: 0)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    
    private func configCell(forCell cell: ImagesListCell, withModel model: Photo) -> ImagesListCell {
        
        if let placeHolderImage = UIImage(named: "ImageStub") {
            var gradient = CAGradientLayer()
            
            gradient = addAnimateGradient(to: cell.cellImageView, withSize: cell.frame.size)
            
            cell.cellImageView.kf.setImage(with: URL(string: model.thumbImageURL),
                                    placeholder: nil,
                                    options: nil,
                                    completionHandler: { _ in
                gradient.removeFromSuperlayer()
            })
                
            
            
            let likeButtonImage = model.isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
            cell.cellLabel.text = dateFormatter.string(from: model.createdAt ?? Date())
            cell.cellLikeButton.setImage(likeButtonImage, for: .normal)
            cell.imageId = model.id
        }
        return cell
    }
    
    
    private func getCellSize(from imageViewSize: CGSize?) -> CGSize{
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        if let imageViewSize {
            let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
            let cellWidth = imageViewSize.width
            let scale = imageViewWidth / cellWidth
            let cellHeight = (imageViewSize.height * scale + imageInsets.top + imageInsets.bottom)
            return CGSize(width: cellWidth, height: cellHeight)
        }
        else {
            let cellWidth = tableView.bounds.width
            let cellHeight = 200.0
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count - 10
        let newCount = oldCount + (imagesListService.photos?.count ?? 0)
        
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}


// MARK: - Extensions

extension ImagesListViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cellSize = getCellSize(from: CGSize(width: photos[indexPath.row].size.width,
                                                height: photos[indexPath.row].size.height))
        return cellSize.height
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switchToSingleImageView(indexPath: indexPath)
    }
    
    
    func tableView(
      _ tableView: UITableView,
      willDisplay cell: UITableViewCell,
      forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}


extension ImagesListViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        return configCell(forCell: imageListCell, withModel: photos[indexPath.row])
    }
}
