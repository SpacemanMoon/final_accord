import UIKit
//MARK: - CAGradientLayer Background
extension CAGradientLayer {
    static func appBackgroundGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        
        let topColor = UIColor(red: 0.13, green: 0.15, blue: 0.17, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 0.08, green: 0.09, blue: 0.11, alpha: 1.0).cgColor
        
        gradient.colors = [topColor, bottomColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        return gradient
    }
}
