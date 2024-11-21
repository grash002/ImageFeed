import Foundation
import UIKit

class ImagesListAnimateHelper: ImagesListAnimateHelperProtocol {
    
    func addAnimateGradient(to imageView: UIImageView, withSize size: CGSize) -> CAGradientLayer {
        
        let gradientImage = configGradient(cornerRadius:
                                            imageView.layer.cornerRadius,
                                           size: size)
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        
        [gradientImage].forEach {
            $0.add(gradientChangeAnimation, forKey: "locationsChange")
        }
        
        imageView.layer.addSublayer(gradientImage)
        return gradientImage
    }
    
    
    private func configGradient(cornerRadius: CGFloat, size: CGSize) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: .zero, size: size)
        gradient.cornerRadius = cornerRadius
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(named: "YPGrey")?.cgColor ?? UIColor.lightGray.cgColor,
            UIColor(named: "YPMidGrey")?.cgColor ?? UIColor.gray.cgColor,
            UIColor(named: "YPDarkGrey")?.cgColor ?? UIColor.darkGray.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.masksToBounds = true
        return gradient
    }
}
