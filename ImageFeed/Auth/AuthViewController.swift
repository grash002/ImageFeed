import UIKit

final class AuthViewController: UIViewController {
    
    
    // MARK: - Public Properties
    weak var delegate: AuthViewControllerDelegate?
    
    
    // MARK: - Private Properties
    private let storageService = StorageService.shared
    private let oAuth2Service = OAuth2Service.shared
    private let jsonDecoder = JSONDecoder()
    private let showWebViewSegueIdentifier = "ShowWebView"
    
    
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
        oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard   let self = self else { return }
            switch result {
            case .success(let stringData):
                let data = Data(stringData.utf8)
                
                do {
                    let oAuthTokenResponseBody = try jsonDecoder.decode(OAuthTokenResponseBody.self, from: data)
                    storageService.userAccessToken = oAuthTokenResponseBody.access_token
                }
                catch {
                    print(error.localizedDescription)
                }
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

extension AuthViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
                return
            }
            webViewViewController.delegate = self
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - Protocols
protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}


