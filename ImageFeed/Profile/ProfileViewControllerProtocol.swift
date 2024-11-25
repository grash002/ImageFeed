import UIKit

protocol ProfileViewControllerProtocol: UIViewController {
    
    var presenter: ProfileViewPresenterProtocol? { get set }
    var animationLayers: Set<CALayer> {get set}
    var imageView: UIImageView {get set}
    var nameLabel: UILabel {get set}
    var userNameLabel: UILabel {get set}
    var userBioLabel: UILabel {get set}
    
    func updateAvatar()
}
