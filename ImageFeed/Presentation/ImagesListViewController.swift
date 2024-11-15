import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var imagesListServiceObserver: NSObjectProtocol?
    private let currentDate = Date()
    
    private var photos: [Photo] = []
    private let imagesListService = ImagesListService()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    // MARK: - @IBOutlet
    
    private var tableView = UITableView()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setImagesListView()
        imagesListService.fetchPhotosNextPage()
        
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(forName: ImagesListService.didChangeNotification,
                         object: nil,
                         queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.photos.append(contentsOf: imagesListService.photos ?? [])
                self.updateTableViewAnimated()
            }
    }
    
    
    // MARK: - Private methods
    private func switchToSingleImageView(indexPath: IndexPath) {
        let singleImageViewController = SingleImageViewController()
        let placeholder = UIImage(named: "ImageStub")
        guard let url = URL(string: photos[indexPath.row].largeImageURL) else {
            return
        }
        singleImageViewController.imageView.kf.setImage(with: url,
                                                        placeholder: placeholder)
        
        
        singleImageViewController.modalPresentationStyle = .fullScreen
        present(singleImageViewController, animated: true)
    }
    
    
    private func setImagesListView() {
        view.backgroundColor = UIColor(named: "YPBlack")
        
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
            cell.cellImageView.kf.indicatorType = .activity
            cell.cellImageView.kf.setImage(with: URL(string: model.thumbImageURL),
                                           placeholder:placeHolderImage)
            
            let likeButtonImage = model.isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
            cell.cellLabel.text = dateFormatter.string(from: model.createdAt ?? Date())
            cell.cellLikeButton.setImage(likeButtonImage, for: .normal)
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
