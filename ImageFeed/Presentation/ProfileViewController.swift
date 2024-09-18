import UIKit
final class ProfileViewController:UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.setTitle("", for: .normal)
        
    }
    @IBOutlet weak var logoutButton: UIButton!
}
