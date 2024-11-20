import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    
    func loadAuthView()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}
