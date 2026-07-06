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
    }
    
    private func setupLayers() {
        let gradientLayer = gradientLayer()
        let squareLayer = squareLayer()
        
        let (gradientAnimation, ringAnimation, squareAnimation) =
//        DispatchQueue.global().sync {
            (
                gradientColorsAnimation(using: gradientLayer.colors),
                ringLayerAnimation(),
                squareLayerAnimation(
                    from: squareLayer.position.x - 60,
                    toValue: squareLayer.position.x + 60
                )
            )
//        }
        
        gradientLayer.add(gradientAnimation, forKey: "gradientColorShift")
        view.layer.addSublayer(gradientLayer)
        
        let ringLayer = ringLayer()
        
        gradientLayer.addSublayer(ringLayer)
        ringLayer.add(ringAnimation, forKey: "ringDrawAndSpin")
        
        squareLayer.add(squareAnimation, forKey: "squareMoveLeftRight")
        gradientLayer.addSublayer(squareLayer)
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
    
    private func squareLayer() -> CAShapeLayer {
        let squareLayer = CAShapeLayer()
        
        let squareSize: CGFloat = 60
        
        squareLayer.bounds = CGRect(
            x: 0,
            y: 0,
            width: squareSize,
            height: squareSize
        )
        squareLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        
        squareLayer.path = UIBezierPath(
            roundedRect: CGRect(x: 0, y: 0, width: squareSize, height: squareSize),
            cornerRadius: 12
        ).cgPath
        
        squareLayer.fillColor = UIColor.systemYellow.cgColor
        squareLayer.cornerCurve = .continuous
        
        return squareLayer
    }
    
    private func squareLayerAnimation(
        from value: Any?,
        toValue: Any?,
    ) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "position.x")
        
        animation.fromValue = value
        animation.toValue = toValue
        animation.duration = 1.4
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        return animation
    }
    
}
