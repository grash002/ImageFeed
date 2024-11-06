import UIKit
import Kingfisher


final class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    
    
    private var imageView: UIImageView = UIImageView()
    private var imageProfile: UIImage?
    private var nameLabel: UILabel?
    private var userNameLabel: UILabel?
    private var userBioLabel: UILabel?
    private var profileService = ProfileService.shared
    private var profileImageService = ProfileImageService.shared
    private var storageService = StorageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Overrides Methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPBlack")
        
        guard storageService.userAccessToken != nil else {
            assertionFailure("User token is nil")
            return
        }
        guard let profile = profileService.profile else {
            assertionFailure("User profile is nil")
            return
        }
        setProfileData(from: profile)
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(forName: ProfileImageService.didChangeNotification,
                         object: nil,
                         queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    // MARK: - Private Methods
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let placeHolderImage = UIImage(named: "Stub")
        else { return }
        
        //ImageCache.default.clearDiskCache()
        //ImageCache.default.clearMemoryCache()
        
        self.imageView.kf.setImage(with: profileImageURL,
                                   placeholder:placeHolderImage)
    }
    
    
    private func setProfileData(from profile: Profile) {
        
        
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        
        let nameLabel = UILabel()
        nameLabel.text = profile.name
        nameLabel.textColor = UIColor(named: "YPWhite")
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        self.nameLabel = nameLabel
        
        let userNameLabel = UILabel()
        userNameLabel.text = profile.loginName
        userNameLabel.textColor = UIColor(named: "YPGrey")
        userNameLabel.font = userNameLabel.font.withSize(13)
        self.userNameLabel = userNameLabel
        
        
        
        
        
        let userBioLabel = UILabel()
        userBioLabel.text = profile.bio
        userBioLabel.textColor = UIColor(named: "YPWhite")
        userBioLabel.font = userBioLabel.font.withSize(13)
        self.userBioLabel = userBioLabel
        
        let logoutButton = UIButton(type: .custom)
        logoutButton.addTarget(self, action: #selector(Self.logoutButtonDidTap), for: .touchUpInside)
        logoutButton.setImage(UIImage(named: "Exit") ?? UIImage(), for: .normal)
        
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
        
        imageView.image = UIImage(named: "Stub")
        
        [nameLabel,
         userNameLabel,
         userBioLabel].forEach{
            $0?.removeFromSuperview()
        }
        
        nameLabel = nil
        userNameLabel = nil
        userBioLabel = nil
        storageService.deleteToken()
    }
}
