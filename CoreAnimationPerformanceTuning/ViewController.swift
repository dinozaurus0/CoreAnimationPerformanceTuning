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
        
        let (gradientAnimation, ringAnimation) =
        DispatchQueue.global().sync {
            (
                gradientColorsAnimation(using: gradientLayer.colors),
                ringLayerAnimation()
            )
        }
        
        gradientLayer.add(gradientAnimation, forKey: "gradientColorShift")
        view.layer.addSublayer(gradientLayer)
        
        let ringLayer = ringLayer()
        
        gradientLayer.addSublayer(ringLayer)
        ringLayer.add(ringAnimation, forKey: "ringDrawAndSpin")
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
    
    private func ringLayer() -> CAShapeLayer {
        let ringLayer = CAShapeLayer()
        
        let ringSize: CGFloat = 200
        ringLayer.bounds = CGRect(
            x: 0,
            y: 0,
            width: ringSize,
            height: ringSize
        )
        ringLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        
        ringLayer.path = UIBezierPath(
            ovalIn: CGRect(x: 0, y: 0, width: ringSize, height: ringSize).insetBy(dx: 3, dy: 3)
        ).cgPath
        
        ringLayer.fillColor = UIColor.clear.cgColor
        ringLayer.strokeColor = UIColor.white.cgColor
        ringLayer.lineWidth = 6
        ringLayer.lineCap = .round
        
        return ringLayer
    }
    
    private func ringLayerAnimation() -> CAAnimationGroup {
        let stroke = CABasicAnimation(keyPath: "strokeEnd")
        stroke.fromValue = 0
        stroke.toValue = 1
        stroke.duration = 2
        stroke.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 8
        rotation.repeatCount = .infinity

        let group = CAAnimationGroup()
        group.animations = [stroke, rotation]
        group.duration = 8
        group.repeatCount = .infinity
        
        return group
    }
    
}
