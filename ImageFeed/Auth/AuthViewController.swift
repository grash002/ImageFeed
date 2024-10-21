import UIKit

final class AuthViewController:UIViewController {
    
    
    // MARK: - Public Properties
    var delegate: AuthViewControllerDelegate?
    
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        configureBackButton()
    }
    
    
    // MARK: - Public Methods
    func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Backward_black")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Backward_black")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YPBlack")
    }
    
    
}
    // MARK: - Extensions
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        OAuth2Service.fetchOAuthToken(code: code) { [self] result in
            switch result {
            case .success(let oAuthTokenResponseBody):
                let storageService = StorageService()
                storageService.userAccessToken = oAuthTokenResponseBody.access_token
                delegate = SplashViewController()
                delegate?.didAuthenticate(self)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}

// MARK: - Protocols
protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}


