import UIKit

final class SplashViewController: UIViewController {
    
    
    // MARK: - Private properties
    private let storageService = StorageService.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    // MARK: - Overrides Methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = storageService.userAccessToken {
            fetchProfile(token: token)
        }
        else {
            switchToAuthViewController()
        }
    }
    
    
    override func viewDidLoad() {
        setSplashView()
        super.viewDidLoad()
    }
    
    
    // MARK: - Private Methods
    private func setSplashView() {
        
        view.backgroundColor = UIColor(named: "YPBlack")
        let image = UIImage(named: "Vector")
        let imageView = UIImageView(image: image)
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo:
                                                view.safeAreaLayoutGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo:
                                                view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
    }
    
    
    private func switchToAuthViewController() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
    
    
    private func switchToTabBarController() {
        
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
    }
    
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) {[weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                
                self.profileImageService.fetchProfileImageURL(username: profile.userName)
                
                self.profileService.profile = profile
                self.switchToTabBarController()
            case .failure(let error):
                print("[fetchProfile]: Error. \(error.localizedDescription)")
                AlertPresenter.showAlert(delegate: self,
                                         alertModel: AlertModel(title: "Что-то пошло не так(",
                                                           message: "Не удалось войти в систему",
                                                                actions: [UIAlertAction(title: "OK", style: .default) { [weak self]_ in
                    guard let self else { return }
                    storageService.deleteToken()
                    switchToAuthViewController()
                }]))
            }
            
        }
    }
    
}


// MARK: - Extensions
extension SplashViewController: AuthViewControllerDelegate {
    
    func didAuthenticate(_ vc: AuthViewController) {
        guard let token = storageService.userAccessToken else {
            assertionFailure("[didAuthenticate] - Failed to get token after auth")
            return }
        fetchProfile(token: token)
        
        vc.dismiss(animated: true)
    }
    
    func didNotAuthenticate(_ vc: AuthViewController) {
        switchToAuthViewController()
    }
}
