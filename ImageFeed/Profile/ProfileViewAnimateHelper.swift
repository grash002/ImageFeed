import UIKit

class ProfileViewAnimateHelper: ProfileViewAnimateHelperProtocol {
    func addAnimateGradient() {
        weak var view: ProfileViewControllerProtocol?
        
        let gradientImage = configGradient(cornerRadius: 35,
                                           size: CGSize(width: 70,
                                                        height: 70))
        let gradientNameLabel = configGradient(cornerRadius: 9,
                                               size: CGSize(width: 223,
                                                            height: 18))
        let gradientUserNameLabel = configGradient(cornerRadius: 9,
                                                   size: CGSize(width: 89,
                                                                height: 18))
        let gradientBioLabel = configGradient(cornerRadius: 9,
                                              size: CGSize(width: 67,
                                                           height: 18))
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        
        [gradientImage,
         gradientNameLabel,
         gradientUserNameLabel,
         gradientBioLabel].forEach {
            $0.add(gradientChangeAnimation, forKey: "locationsChange")
            view?.animationLayers.insert($0)
        }
        
        view?.imageView.layer.addSublayer(gradientImage)
        view?.nameLabel.layer.addSublayer(gradientNameLabel)
        view?.userNameLabel.layer.addSublayer(gradientUserNameLabel)
        view?.userBioLabel.layer.addSublayer(gradientBioLabel)
    }
    
    
    private func configGradient(cornerRadius: CGFloat, size: CGSize) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: .zero, size: size)
        gradient.cornerRadius = cornerRadius
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(named: "YPGray") ?? UIColor.gray,
            UIColor(named: "YPMidGrey") ?? UIColor.gray,
            UIColor(named: "YPDarkGrey") ?? UIColor.gray
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.masksToBounds = true
        return gradient
    }
}
