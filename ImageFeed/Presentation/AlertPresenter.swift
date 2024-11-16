import Foundation
import UIKit

final class AlertPresenter {
    
    static func showAlert(delegate: UIViewController, alertModel: AlertModel) {
        let alert = UIAlertController(title: alertModel.title,
                                      message: alertModel.message,
                                      preferredStyle: .alert)
        alertModel.actions.map { alert.addAction($0) }
        delegate.present(alert, animated: true)
    }
}

