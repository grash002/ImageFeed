import Foundation
import UIKit
import Kingfisher

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    private var profileViewAnimateHelper = ProfileViewAnimateHelper()
    private var profileService = ProfileService.shared
    private var profileImageServiceObserver = NotificationCenter.default
    private var storageService = StorageService.shared
    private var imagesListService = ImagesListService.shared
    private var profileImageService = ProfileImageService.shared
    
    func viewDidLoad() {
        profileImageServiceObserver.addObserver(forName: ProfileImageService.didChangeNotification,
                         object: nil,
                         queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.view?.updateAvatar()
            }
        view?.updateAvatar()
    }
    
    
    func getProfile() -> Profile? {
        profileService.profile
    }
    
    func logoutButtonDidTap() {
        storageService.deleteToken()
        imagesListService.resetService()                
        
        let splashViewController = SplashViewController()
        splashViewController.modalPresentationStyle = .fullScreen
        view?.present(splashViewController, animated: true)
    }
    
    func addAnimateGradient() {
        profileViewAnimateHelper.addAnimateGradient()
    }
}
