import UIKit
@testable import ImageFeed
final class ProfileViewControllerSpy: UIViewController & ProfileViewControllerProtocol {
    var presenter: (any ImageFeed.ProfileViewPresenterProtocol)?
    
    
    var animationLayers: Set<CALayer> = Set<CALayer>()
    var imageView: UIImageView = UIImageView()
    var nameLabel: UILabel = UILabel()
    var userNameLabel: UILabel = UILabel()
    var userBioLabel: UILabel = UILabel()
    
    func updateAvatar() {
        
    }
    
    
}
