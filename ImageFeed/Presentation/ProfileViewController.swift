import UIKit
import Kingfisher


final class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var animationLayers = Set<CALayer>()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        return imageView
    }()
    private var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor(named: "YPWhite")
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        return nameLabel
    }()
    private var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.textColor = UIColor(named: "YPGrey")
        userNameLabel.font = userNameLabel.font.withSize(13)
        return userNameLabel
    }()
    private var userBioLabel: UILabel = {
        let userBioLabel = UILabel()
        userBioLabel.textColor = UIColor(named: "YPWhite")
        userBioLabel.font = userBioLabel.font.withSize(13)
        return userBioLabel
    }()
    
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
        
        
        self.animationLayers.forEach {
            $0.removeFromSuperlayer()
        }
        self.imageView.kf.setImage(with: profileImageURL,
                                   placeholder:placeHolderImage)
    }
    
    
    private func addAnimateGradient() {
        
        let gradientImage = configGradient(cornerRadius: 35,
                                           size: CGSize(width: 70,
                                                        height: 70))
        let gradientNameLabel = configGradient(cornerRadius: 9,
                                               size: CGSize(width: 223,
                                                            height: 18))
        let gradientUserNameLabel = configGradient(cornerRadius: 9,
                                                   size: CGSize(width: 89,
                                                                height: 18))
        let gradientBioLabel = configGradient(cornerRadius: 9,
                                              size: CGSize(width: 67,
                                                           height: 18))
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        
        [gradientImage,
         gradientNameLabel,
         gradientUserNameLabel,
         gradientBioLabel].forEach {
            $0.add(gradientChangeAnimation, forKey: "locationsChange")
            animationLayers.insert($0)
        }
        
        imageView.layer.addSublayer(gradientImage)
        nameLabel.layer.addSublayer(gradientNameLabel)
        userNameLabel.layer.addSublayer(gradientUserNameLabel)
        userBioLabel.layer.addSublayer(gradientBioLabel)
    }
    
    
    private func configGradient(cornerRadius: CGFloat, size: CGSize) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: .zero, size: size)
        gradient.cornerRadius = cornerRadius
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(named: "YPGray") ?? UIColor.gray,
            UIColor(named: "YPMidGrey") ?? UIColor.gray,
            UIColor(named: "YPDarkGrey") ?? UIColor.gray
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.masksToBounds = true
        return gradient
    }
    
    
    private func setProfileData(from profile: Profile) {
        addAnimateGradient()
        
        self.nameLabel.text = profile.name
        self.userNameLabel.text = profile.loginName
        self.userBioLabel.text = profile.bio
        
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
                self.storageService.deleteToken()
                
                let splashViewController = SplashViewController()
                splashViewController.modalPresentationStyle = .fullScreen
                present(splashViewController, animated: true)
            }, 
                                                UIAlertAction(title: "Нет", style: .default)
           ]))
    }
}
