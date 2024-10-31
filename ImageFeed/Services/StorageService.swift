import Foundation

final class StorageService {
    
    // MARK: - Public Properties
    static let shared = StorageService()
    
    var userAccessToken: String? {
        get {
            storage.string(forKey: Keys.userAccessToken.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.userAccessToken.rawValue)
        }
    }
    
    
    // MARK: - Private Properties
    private let storage = UserDefaults.standard
    
    private enum Keys: String {
        case userAccessToken
    }
    
    // MARK: - Init
    private init() {}
}
