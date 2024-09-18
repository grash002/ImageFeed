import UIKit

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    

    
    // MARK: - @IBOutlet
    
    @IBOutlet private var cellLabel: UILabel!
    @IBOutlet private var cellLikeButton: UIButton!
    @IBOutlet private var cellImageView: UIImageView!
    
    // MARK: - Private properties
    
    private var likeButtonTapped = false
    
    func configCell(for model: PhotoModel) {
        if let image = UIImage(named: model.imageName) {
            
            let likeButtonImage = model.imageIndex%2 == 0 ? UIImage(named: "Active") : UIImage(named: "No Active")
            self.cellLikeButton.setImage(likeButtonImage, for: .normal)
            
            
            self.cellImageView.layer.cornerRadius = 16
            self.cellImageView.layer.masksToBounds = true
            
            self.cellImageView.image = image
            self.cellLabel.text = model.imageText
        }
    }
    
    // MARK: - @IBAction
    
    @IBAction func likeButtonDidTap(_ sender: Any) {
        likeButtonTapped = !likeButtonTapped
        let likeButtonImage = likeButtonTapped ? UIImage(named: "Active") : UIImage(named: "No Active")
        cellLikeButton.setImage(likeButtonImage, for: .normal)
    }
    
}
