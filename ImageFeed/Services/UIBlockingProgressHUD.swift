import UIKit
import ProgressHUD


final class UIBlockingProgressHUD {
    
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }
    
    static func showWithOutAnim() {
        window?.isUserInteractionEnabled = false
    }
    
    static func dismissWithOutAnim() {
        window?.isUserInteractionEnabled = true
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }

}
