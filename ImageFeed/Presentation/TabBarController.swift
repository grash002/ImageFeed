import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imagesListViewController = ImagesListViewController()
        let imagesListViewPresenter = ImagesListViewPresenter()
        
        imagesListViewController.presenter = imagesListViewPresenter
        imagesListViewPresenter.view = imagesListViewController
        
        imagesListViewController.tabBarItem = UITabBarItem(title: "",
                                                        image: UIImage(named: "tab_editorial_active"),
                                                        selectedImage: nil)
        let profileViewController = ProfileViewController()
        let profileViewPresenter = ProfileViewPresenter()
        
        profileViewController.presenter = profileViewPresenter
        profileViewPresenter.view = profileViewController
        
        profileViewController.tabBarItem = UITabBarItem(title: "",
                                                        image: UIImage(named: "tab_profile_active"),
                                                        selectedImage: nil)
        self.tabBar.barTintColor = .black
        self.viewControllers = [imagesListViewController,profileViewController]
    }
}

