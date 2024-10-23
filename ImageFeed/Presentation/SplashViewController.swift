import UIKit

final class SplashViewController: UIViewController {
    
    
    // MARK: - Private properties
    private let storageService = StorageService.shared
    private let showAuthenticationScreenSegueIdentifier = "AuthenticationScreen"
    private let showImagesScreenSegueIdentifier = "ImagesScreen"
    
    
    // MARK: - Overrides Methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if storageService.userAccessToken != nil {
            performSegue(withIdentifier: showImagesScreenSegueIdentifier,
                         sender: nil)
        }
        else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier,
                         sender: nil)
        }
    }
    
    
    // MARK: - Private Methods
    private func switchToTabBarController() {
        
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}


// MARK: - Extensions
extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            viewController.delegate = self
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        switchToTabBarController()
    }
}
