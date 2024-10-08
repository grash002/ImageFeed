import UIKit

final class ImagesListCell: UITableViewCell {
    
    // MARK: - @IBOutlet
    
    @IBOutlet var cellLabel: UILabel!
    @IBOutlet var cellLikeButton: UIButton!
    @IBOutlet var cellImageView: UIImageView!
    
    
    // MARK: - Public Properties
    
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - Private properties
    
    private var likeButtonTapped = false
    
    
    // MARK: - @IBAction
    
    @IBAction func likeButtonDidTap(_ sender: Any) {
        likeButtonTapped = !likeButtonTapped
        let likeButtonImage = likeButtonTapped ? UIImage(named: "Active") : UIImage(named: "No Active")
        cellLikeButton.setImage(likeButtonImage, for: .normal)
    }
    
}
