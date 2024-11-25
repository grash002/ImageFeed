import Foundation
import WebKit

class AuthHelper: AuthHelperProtocol {
   
    let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    func authUrl() -> URL? {
        guard var urlComponents = URLComponents(string: configuration.authURLString) else {
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope)
        ]
        return urlComponents.url
    }
    
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" }) {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    func authRequest() -> URLRequest? {
        guard let url = authUrl() else { return nil }
        return URLRequest(url: url)
    }
    
    
    
    func clearWebViewData(completion: @escaping () -> Void) {
        let websiteDataTypes = Set([WKWebsiteDataTypeCookies, WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeLocalStorage])
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: websiteDataTypes) { records in
            
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, for: records) {
                completion()
            }
        }
        HTTPCookieStorage.shared.removeCookies(since: .distantPast)
    }
}