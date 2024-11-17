import UIKit

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Public Properties
    
    static let reuseIdentifier = "ImagesListCell"
    static let likeDidChangeNotification = Notification.Name(rawValue: "ImagesListCellLikeDidChange")
    var cellLabel = UILabel()
    var cellLikeButton = UIButton()
    var cellImageView = UIImageView()
    var imageId = ""
    
    // MARK: - Private properties
    
    private var likeButtonTapped = false
    
    
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor(named: "YPBlack")
        self.selectionStyle = .none
        
        cellLikeButton.addTarget(self,
                                 action: #selector(likeButtonDidTap),
                                 for: .touchUpInside)
        
        cellLabel.textColor = UIColor(named: "YPWhite")
        cellLabel.font = UIFont.boldSystemFont(ofSize: 13)
        
        cellImageView.layer.cornerRadius = 16
        cellImageView.layer.masksToBounds = true
        
        contentView.addSubview(cellImageView)
        contentView.addSubview(cellLabel)
        contentView.addSubview(cellLikeButton)
        
        [cellLabel,
         cellLikeButton,
         cellImageView].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            cellLikeButton.heightAnchor.constraint(equalToConstant: 42),
            cellLikeButton.widthAnchor.constraint(equalToConstant: 42),
            cellImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cellImageView.trailingAnchor.constraint(greaterThanOrEqualTo: cellLabel.trailingAnchor, constant: 8),
            cellImageView.trailingAnchor.constraint(equalTo: cellLikeButton.trailingAnchor),
            cellImageView.leadingAnchor.constraint(equalTo: cellLabel.leadingAnchor, constant: -8),
            cellImageView.bottomAnchor.constraint(equalTo: cellLabel.bottomAnchor, constant: 8),
            cellImageView.topAnchor.constraint(equalTo: cellLikeButton.topAnchor)
            
            
        ])
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.kf.cancelDownloadTask()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public methods
    
    @objc
    func likeButtonDidTap(_ sender: Any) {
        likeButtonTapped = !likeButtonTapped
        NotificationCenter.default.post(name: ImagesListCell.likeDidChangeNotification,
                                        object: self,
                                        userInfo: ["imageId" : imageId,
                                                   "isLike":likeButtonTapped])
        setIsLiked(likeButtonTapped)
    }
    
    
    func setIsLiked (_ isLike: Bool) {
        let likeButtonImage = isLike ? UIImage(named: "Active") : UIImage(named: "No Active")
        cellLikeButton.setImage(likeButtonImage, for: .normal)
    }
}
