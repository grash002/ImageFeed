import Foundation
import ImageFeed

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var view: (any ImageFeed.WebViewViewControllerProtocol)?
    var loadAuthViewCalled: Bool = false
    
    func loadAuthView() {
        loadAuthViewCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}

