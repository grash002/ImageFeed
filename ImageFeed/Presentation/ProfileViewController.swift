import UIKit
import Kingfisher


final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    var presenter: ProfileViewPresenterProtocol?
    
    var animationLayers = Set<CALayer>()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        return imageView
    }()
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor(named: "YPWhite")
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        return nameLabel
    }()
    lazy var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.textColor = UIColor(named: "YPGrey")
        userNameLabel.font = userNameLabel.font.withSize(13)
        return userNameLabel
    }()
    lazy var userBioLabel: UILabel = {
        let userBioLabel = UILabel()
        userBioLabel.textColor = UIColor(named: "YPWhite")
        userBioLabel.font = userBioLabel.font.withSize(13)
        return userBioLabel
    }()
    
    // MARK: - Private Properties
    private var profileImageServiceObserver: NSObjectProtocol?

    
        
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPBlack")
        
        guard let profile = presenter?.getProfile() else {
            print("User profile is nil")
            return
        }
        setProfileData(from: profile)
        presenter?.viewDidLoad()
    }
    
    
    // MARK: - Public Methods
    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let placeHolderImage = UIImage(named: "Stub")
        else { return }
        
        
        self.animationLayers.forEach {
            $0.removeFromSuperlayer()
        }
        self.imageView.kf.setImage(with: profileImageURL,
                                   placeholder:placeHolderImage)
    }
    
    
    // MARK: - Private Methods
    
    
    private func setProfileData(from profile: Profile) {
        presenter?.addAnimateGradient()
        
        self.nameLabel.text = profile.name
        self.userNameLabel.text = profile.loginName
        self.userBioLabel.text = profile.bio
        
        let logoutButton = UIButton(type: .custom)
        logoutButton.addTarget(self, action: #selector(Self.logoutButtonDidTap), for: .touchUpInside)
        logoutButton.setImage(UIImage(named: "Exit") ?? UIImage(), for: .normal)
        logoutButton.accessibilityIdentifier = "logout button"
        
        let stackView = UIStackView(arrangedSubviews:
                                        [imageView,
                                         nameLabel,
                                         userNameLabel,
                                         userBioLabel])
        
        
        view.addSubview(stackView)
        view.addSubview(logoutButton)
        
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        
        stackView.spacing = 8
        
        [imageView,
         nameLabel,
         userNameLabel,
         userBioLabel,
         logoutButton,
         stackView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: logoutButton.leadingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            logoutButton.heightAnchor.constraint(equalToConstant: 24),
            logoutButton.widthAnchor.constraint(equalToConstant: 24),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55)
        ])
        
    }
    
    
    @objc
    private func logoutButtonDidTap() {
        AlertPresenter.showAlert(delegate: self,
                                 alertModel:
                                    AlertModel(title: "Пока, пока!",
                                               message: "Уверены, что хотите выйти?",
                                               actions: [
                                                UIAlertAction(title: "Да",
                                                              style: .default)
            { [weak self] _ in
                guard let self else { return }
                self.imageView.image = UIImage(named: "Stub")
                
                [self.nameLabel,
                 self.userNameLabel,
                 self.userBioLabel].forEach{
                    $0?.removeFromSuperview()
                }
                
                self.nameLabel.text = ""
                self.userNameLabel.text = ""
                self.userBioLabel.text = ""
                presenter?.logoutButtonDidTap()
            }, 
                                                UIAlertAction(title: "Нет", style: .default)
           ]))
    }
}
