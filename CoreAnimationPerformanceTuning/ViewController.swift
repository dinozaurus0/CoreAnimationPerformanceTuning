import UIKit

final class ViewController: UIViewController {
    private var bounds: CGRect = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bounds = view.bounds
        
        let clock = ContinuousClock()
        let elapsed = clock.measure {
            setupLayers()
        }
        
        print("Took \(elapsed)")
        // Took 0.002885042 seconds
    }
    
    private func setupLayers() {
        let gradientLayer = gradientLayer()
        let gradientAnimation =
//        DispatchQueue.global().sync {
            gradientColorsAnimation(using: gradientLayer.colors)
//        }
        
        gradientLayer.add(gradientAnimation, forKey: "gradientColorShift")
        view.layer.addSublayer(gradientLayer)
    }
    
    private func gradientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.bounds = bounds
        gradientLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        
        gradientLayer.colors = [
            UIColor.systemPurple.cgColor,
            UIColor.systemBlue.cgColor,
            UIColor.systemTeal.cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        return gradientLayer
    }
    
    private func gradientColorsAnimation(
        using colors: [Any]?
    ) -> CABasicAnimation {
        let colorAnimation = CABasicAnimation(keyPath: "colors")
        
        colorAnimation.fromValue = colors
        
        colorAnimation.toValue = [
            UIColor.systemTeal.cgColor,
            UIColor.systemPurple.cgColor,
            UIColor.systemBlue.cgColor
        ]
        
        colorAnimation.duration = 4
        colorAnimation.autoreverses = true
        colorAnimation.repeatCount = .infinity
        colorAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        return colorAnimation
    }
    
}
