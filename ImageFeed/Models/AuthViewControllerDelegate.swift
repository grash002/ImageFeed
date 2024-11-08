import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
    func didNotAuthenticate(_ vc: AuthViewController)
}
