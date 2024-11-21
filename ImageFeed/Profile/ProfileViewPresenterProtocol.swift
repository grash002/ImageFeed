import Foundation

protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    
    func logoutButtonDidTap()
    func addAnimateGradient()
    func getProfile() -> Profile?
    func viewDidLoad()
}
