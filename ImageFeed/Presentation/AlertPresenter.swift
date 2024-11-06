import Foundation
import UIKit

final class AlertPresenter {
    
    static func showAuthAlert(delegate: UIViewController) {
        let alert = UIAlertController(title: "Что-то пошло не так(",
                                      message: "Не удалось войти в систему",
                                      preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(alertAction)
        delegate.present(alert, animated: true)
    }
}
