import UIKit
final class ProfileViewController:UIViewController {
    
    private var imageView: UIImageView?
    private var nameLabel: UILabel?
    private var userNameLabel: UILabel?
    private var userStatusLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setProfileData()
    }
    
    private func setProfileData() {
        let imageView = UIImageView(image: UIImage(named: "Profile photo"))
        self.imageView = imageView
        
        
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        self.nameLabel = nameLabel
        nameLabel.textColor = UIColor(named: "YPWhite")
        nameLabel.font = nameLabel.font.withSize(23)
        
        
        let userNameLabel = UILabel()
        userNameLabel.text = "@ekaterina_nov"
        self.userNameLabel = userNameLabel
        userNameLabel.textColor = UIColor(named: "YPGrey")
        userNameLabel.font = userNameLabel.font.withSize(13)
        
        
        let userStatusLabel = UILabel()
        userStatusLabel.text = "Hello, world!"
        self.userStatusLabel = userStatusLabel
        userStatusLabel.textColor = UIColor(named: "YPWhite")
        userStatusLabel.font = userStatusLabel.font.withSize(13)
        
        
        let logoutButton = UIButton(type: .custom)
        logoutButton.addTarget(self, action: #selector(Self.logoutButtonDidTap), for: .touchUpInside)
        logoutButton.setImage(UIImage(named: "Exit") ?? UIImage(), for: .normal)
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        let stackView = UIStackView(arrangedSubviews: [imageView,nameLabel,userNameLabel,userStatusLabel])
        
        
        view.addSubview(stackView)
        view.addSubview(logoutButton)
        
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: logoutButton.leadingAnchor).isActive = true
        
        stackView.spacing = 8
        
        
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        
        logoutButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55).isActive = true
    }
    
    
    @objc
    private func logoutButtonDidTap() {
        imageView?.image = UIImage(named: "Stub")
        nameLabel?.removeFromSuperview()
        nameLabel = nil
        userNameLabel?.removeFromSuperview()
        userNameLabel = nil
        userStatusLabel?.removeFromSuperview()
        userStatusLabel = nil
    }
}
