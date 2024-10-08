import UIKit

final class ImagesListViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let currentDate = Date()
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    // MARK: - @IBOutlet
    
    @IBOutlet private var tableView: UITableView!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12,
                                              left: 0,
                                              bottom: 0,
                                              right: 0)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController,
                  let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    
    // MARK: - Private methods
    
    private func configCell(forCell cell: ImagesListCell, withModel model: PhotoModel) -> ImagesListCell {
        if let image = UIImage(named: model.imageName) {
            
            let likeButtonImage = model.imageIndex%2 == 0 ? UIImage(named: "Active") : UIImage(named: "No Active")
            
            cell.cellImageView.layer.cornerRadius = 16
            cell.cellImageView.layer.masksToBounds = true
            cell.cellImageView.image = image
            
            cell.cellLabel.text = model.imageText
            cell.cellLikeButton.setImage(likeButtonImage, for: .normal)
        }
        return cell
    }
    
    
    private func getCellSize(from imageView: UIImageView?) -> CGSize{
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        if let imageView = imageView {
            let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
            let cellWidth = imageView.image?.size.width ?? 0
            let scale = imageViewWidth / cellWidth
            let cellHeight = ((imageView.image?.size.height ?? 0) * scale + imageInsets.top + imageInsets.bottom)
            return CGSize(width: cellWidth, height: cellHeight)
        }
        else {
            let cellWidth = tableView.bounds.width
            let cellHeight = 200.0
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    
    
    private func addGradient(imageView: UIImageView) {
        let gradient:CAGradientLayer = CAGradientLayer()
        let cellSize = getCellSize(from: nil)
        gradient.frame.size = cellSize
        
        gradient.colors = [
            UIColor.white.cgColor,
            UIColor.white.withAlphaComponent(0).cgColor
        ]
        
        imageView.layer.addSublayer(gradient)
    }
}


    // MARK: - Extensions

extension ImagesListViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        
        let cellSize = getCellSize(from: UIImageView(image: image))
        
        return cellSize.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
        }
}


extension ImagesListViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        let photoModel = PhotoModel(imageName: photosName[indexPath.row], 
                                    imageText: dateFormatter.string(from: currentDate),
                                    imageIndex: indexPath.row)
        
        return configCell(forCell: imageListCell, withModel: photoModel)
    }
}
