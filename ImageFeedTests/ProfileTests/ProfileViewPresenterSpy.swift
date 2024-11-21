import Foundation
@testable import ImageFeed

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: (any ImageFeed.ProfileViewControllerProtocol)?
    
    var viewDidLoadCalled = false
    
    func logoutButtonDidTap() {
        
    }
    
    func addAnimateGradient() {
        
    }
    
    func getProfile() -> ImageFeed.Profile? {
        return Profile (userName: "userNameTest",
                        name: "nameTest",
                        loginName: "loginNameTest",
                        bio: "bioTest")
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    
}
