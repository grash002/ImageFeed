import Foundation
import ImageFeed

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: (any ImageFeed.WebViewPresenterProtocol)?
    var loadAuthViewCalled: Bool = false
    var loadAuthViewCalledHandler: (()->Void)?
    
    func loadAuthView(request: URLRequest) {
        loadAuthViewCalled = true
        loadAuthViewCalledHandler?()
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
    
    
}
