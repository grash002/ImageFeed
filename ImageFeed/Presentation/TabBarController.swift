import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        //let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        let imagesListViewController = ImagesListViewController()
        imagesListViewController.tabBarItem = UITabBarItem(title: "",
                                                        image: UIImage(named: "tab_editorial_active"),
                                                        selectedImage: nil)
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "",
                                                        image: UIImage(named: "tab_profile_active"),
                                                        selectedImage: nil)
        self.tabBar.barTintColor = .black
        self.viewControllers = [imagesListViewController,profileViewController]
    }
}

