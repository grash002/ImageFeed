import UIKit

class ImagesListViewController: UIViewController {
    // MARK: - @IBOutlet
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Private methods
    
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
        gradient.colors = [UIColor.white.cgColor,UIColor.white.withAlphaComponent(0).cgColor]
        imageView.layer.addSublayer(gradient)
    }
    
    // MARK: - Private properties
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
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
}


extension ImagesListViewController: UITableViewDataSource {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        if let image = UIImage(named: photosName[indexPath.row]) {
            
            let likeButtonImage = indexPath.row%2 == 0 ? UIImage(named: "Active") : UIImage(named: "No Active")
            cell.cellLikeButton.setImage(likeButtonImage, for: .normal)
            
            cell.cellImageView.image = image
            
            cell.cellImageView.layer.cornerRadius = 16
            cell.cellImageView.layer.masksToBounds = true
            
            cell.cellLabel.text = dateFormatter.string(from: Date())
        }
        else {
            addGradient(imageView: cell.cellImageView)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}
