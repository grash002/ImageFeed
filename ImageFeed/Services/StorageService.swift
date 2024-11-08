import WebKit
import SwiftKeychainWrapper

final class StorageService {
    
    // MARK: - Public Properties
    static let shared = StorageService()
    
    var userAccessToken: String? {
        get {
            keychain.string(forKey: Keys.userAccessToken.rawValue)
        }
        set {
            guard let newValue = newValue else { return }
            keychain.set(newValue, forKey: Keys.userAccessToken.rawValue)
        }
    }
    
    
    // MARK: - Private Properties
    private let keychain = KeychainWrapper.standard
    
    private enum Keys: String {
        case userAccessToken
    }
    
    // MARK: - Init
    private init() {}
    
    
    // MARK: - Public methods
    func deleteToken() {
        KeychainWrapper.standard.removeObject(forKey: Keys.userAccessToken.rawValue)
    }
}
