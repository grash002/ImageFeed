import UIKit
final class ProfileViewController:UIViewController {
    
    // MARK: - Private Properties
    
    
    private var imageView: UIImageView?
    private var nameLabel: UILabel?
    private var userNameLabel: UILabel?
    private var userStatusLabel: UILabel?
    
    
    // MARK: - Overrides Methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPBlack")
        
        setProfileData()
    }
    
    
    // MARK: - Private Methods
    
    
    private func setProfileData() {
        let image = UIImage(named: "Profile photo")
        let imageView = UIImageView(image: image)
        self.imageView = imageView
        
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YPWhite")
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        self.nameLabel = nameLabel
        
        let userNameLabel = UILabel()
        userNameLabel.text = "@ekaterina_nov"
        userNameLabel.textColor = UIColor(named: "YPGrey")
        userNameLabel.font = userNameLabel.font.withSize(13)
        self.userNameLabel = userNameLabel
        
        
        let userStatusLabel = UILabel()
        userStatusLabel.text = "Hello, world!"
        userStatusLabel.textColor = UIColor(named: "YPWhite")
        userStatusLabel.font = userStatusLabel.font.withSize(13)
        self.userStatusLabel = userStatusLabel
        
        let logoutButton = UIButton(type: .custom)
        logoutButton.addTarget(self, action: #selector(Self.logoutButtonDidTap), for: .touchUpInside)
        logoutButton.setImage(UIImage(named: "Exit") ?? UIImage(), for: .normal)
        
        let stackView = UIStackView(arrangedSubviews:
                                        [imageView,
                                         nameLabel,
                                         userNameLabel,
                                         userStatusLabel])
        
        
        view.addSubview(stackView)
        view.addSubview(logoutButton)
        

        stackView.axis = .vertical
        stackView.alignment = .leading
        
        stackView.spacing = 8
        
        [imageView,
         nameLabel,
         userNameLabel,
         userStatusLabel,
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
        
        imageView?.image = UIImage(named: "Stub")
        
        [nameLabel,
         userNameLabel,
         userStatusLabel].forEach{
            $0?.removeFromSuperview()
        }
        
        nameLabel = nil
        userNameLabel = nil
        userStatusLabel = nil
        imageView = nil
    }
}
