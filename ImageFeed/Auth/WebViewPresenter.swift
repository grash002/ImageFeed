import Foundation

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    
    private let config: AuthConfiguration
    private let authHelper: AuthHelper
    
    
    init(config: AuthConfiguration = AuthConfiguration.standard,
         authHelper: AuthHelper) {
        self.authHelper = authHelper
        self.config = config
    }
    
    
    func loadAuthView() {
        
        guard   let request = authHelper.authRequest(),
                let view else {
            return
        }
        
        didUpdateProgressValue(0)
        view.loadAuthView(request: request)
    }
    
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}
