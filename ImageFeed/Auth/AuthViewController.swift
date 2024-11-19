import UIKit

final class AuthViewController: UIViewController {
    
    
    // MARK: - Public Properties
    weak var delegate: AuthViewControllerDelegate?
    
    
    // MARK: - Private Properties
    private let storageService = StorageService.shared
    private let oAuth2Service = OAuth2Service.shared
    private let jsonDecoder = JSONDecoder()
    
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        setAuthView()
        configureBackButton()
    }
    
    
    // MARK: - Private Methods
    private func setAuthView() {
        view.backgroundColor = UIColor(named: "YPBlack")
        
        let imageView = UIImageView(image:
                                        UIImage(named: "Logo_of_Unsplash"))
        
        let logInButton = UIButton(type: .custom)
        logInButton.setTitle("Войти", for: .normal)
        logInButton.setTitleColor(UIColor(named: "YPBlack"),
                                  for: .normal)
        logInButton.backgroundColor = UIColor(named: "YPWhite")
        logInButton.addTarget(self, action: #selector(Self.logInButtonDidTap),
                              for: .touchUpInside)
        logInButton.layer.cornerRadius = 16
        
        view.addSubview(imageView)
        view.addSubview(logInButton)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 60),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.centerXAnchor.constraint(equalTo:
                                                view.safeAreaLayoutGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo:
                                                view.safeAreaLayoutGuide.centerYAnchor),
            logInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                  constant: -16),
            logInButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                 constant: 16),
            logInButton.heightAnchor.constraint(equalToConstant: 48),
            logInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                constant: -90)
        ])
    }
    
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Backward_black")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Backward_black")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YPBlack")
    }
    
    @objc
    private func logInButtonDidTap() {
        let webViewViewController = WebViewViewController()
        webViewViewController.delegate = self
        webViewViewController.modalPresentationStyle = .fullScreen
        present(webViewViewController, animated: true)
    }
    
    
}
// MARK: - Extensions
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard   let self = self else { return }
            
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let oAuthTokenResponseBody):
                
                storageService.userAccessToken = "Bearer \(oAuthTokenResponseBody.accessToken)"
                
                delegate?.didAuthenticate(self)
            case .failure(let error):
                AlertPresenter.showAlert(delegate: self,
                                         alertModel: AlertModel(title: "Что-то пошло не так(",
                                                           message: "Не удалось войти в систему",
                                                           actions: [UIAlertAction(title: "OK", style: .default)]))
                delegate?.didNotAuthenticate(self)
                print("[webViewViewController]: Error. \(error.localizedDescription)")
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}


