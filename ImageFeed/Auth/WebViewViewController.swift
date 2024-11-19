import UIKit
import WebKit


final class WebViewViewController: UIViewController {
    
    
    // MARK: - Public Properties
    weak var delegate: WebViewViewControllerDelegate?
    
    
    // MARK: - Private Properties
    private var estimatedProgressObservation: NSKeyValueObservation?
    private var progressView = UIProgressView()
    private var webView = WKWebView()
    
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setWebViewController()
        
        webView.navigationDelegate = self
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             changeHandler: {[weak self] _,_ in
                 guard let self = self else { return }
                 self.updateProgress()
             })
        loadAuthView()
    }
    
    
    // MARK: - Private Methods
    private func setWebViewController() {
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "Backward_black"),
                            for: .normal)
        backButton.addTarget(self, action: #selector(Self.backButtonDidTap),
                             for: .touchUpInside)
        
        view.backgroundColor = UIColor(named: "YPWhite")
        view.addSubview(progressView)
        view.addSubview(webView)
        view.addSubview(backButton)
        
        progressView.progress = 0
        progressView.tintColor = UIColor(named: "YPBlack")
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: -9),
            backButton.bottomAnchor.constraint(equalTo: progressView.topAnchor,
                                               constant: -9),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                constant: 9),
            
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo:
                                                    view.safeAreaLayoutGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
        ])
    }
    
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectUri),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            return
        }
        clearWebViewData {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
    
    
    private func clearWebViewData(completion: @escaping () -> Void) {
        let websiteDataTypes = Set([WKWebsiteDataTypeCookies, WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeLocalStorage])
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: websiteDataTypes) { records in
            
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, for: records) {
                completion()
            }
        }
        HTTPCookieStorage.shared.removeCookies(since: .distantPast)
    }
}

// MARK: - Extensions
extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            decisionHandler(.cancel)
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
        }
        else {
            decisionHandler(.allow)
        }
    }
    
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: {$0.name == "code"})
        {
            return codeItem.value
        }
        else {
            return nil
        }
    }
    @objc
    private func backButtonDidTap() {
        self.dismiss(animated: true)
    }
}


// MARK: - Enum
enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

