import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    // MARK: - Public Properties
    var presenter: ImagesListViewPresenterProtocol?
    var photos: [Photo] = []
    lazy var mockPhoto: Photo? = {
        Photo(id: "MockPhoto",
              size: CGSize(width: 343, height: 252),
              createdAt: Date(),
              welcomeDescription: "",
              thumbImageURL: nil,
              largeImageURL: nil,
              isLiked: false)
    }()
    
    lazy var mockBigPhoto: Photo? = {
        Photo(id: "MockPhoto",
              size: CGSize(width: 343, height: 370),
              createdAt: Date(),
              welcomeDescription: "",
              thumbImageURL: nil,
              largeImageURL: nil,
              isLiked: false)
    }()
    
    var tableView = UITableView()
    
    // MARK: - Private properties
    private let animateHelper = ImagesListAnimateHelper()

    
    // MARK: - Lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setImagesListView()
        
        presenter?.viewDidLoad()
    }
    
    
    // MARK: - Private methods
   private func setImagesListView() {
        view.backgroundColor = UIColor(named: "YPBlack")
        if let mockPhoto,
           let mockBigPhoto {
            photos.append(contentsOf: [mockPhoto,
                                       mockBigPhoto,
                                       mockPhoto,
                                       mockPhoto,
                                       mockPhoto])
        }
        
        
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
        
        var gradient = CAGradientLayer()
        
        gradient = animateHelper.addAnimateGradient(to: cell.cellImageView, withSize: cell.frame.size)
        
        cell.cellImageView.kf.setImage(with: model.thumbImageURL,
                                       placeholder: nil,
                                       options: nil,
                                       completionHandler: { _ in
            gradient.removeFromSuperlayer()
        })
        
        
        
        let likeButtonImage = model.isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
        cell.cellLabel.text = ImagesListViewPresenter.dateFormatter.string(from: model.createdAt ?? Date())
        cell.cellLikeButton.setImage(likeButtonImage, for: .normal)
        cell.imageId = model.id
        
        return cell
    }
    
    
    private func getCellSize(from imageViewSize: CGSize?) -> CGSize{
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        if let imageViewSize {
            let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
            let cellWidth = imageViewSize.width != 0 ? imageViewSize.width : 1
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
    
    
    func updateTableViewAnimated(fromIndex: Int, toIndex: Int) {
        tableView.performBatchUpdates {
            let indexPaths = (fromIndex..<toIndex).map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
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
        presenter?.cellDidTap(indexPath: indexPath)
    }
    
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == photos.count {
            presenter?.fetchPhotosNextPage()
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
