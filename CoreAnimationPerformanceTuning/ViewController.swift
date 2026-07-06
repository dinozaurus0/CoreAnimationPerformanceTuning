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
        
        let (gradientAnimation, ringAnimation, squareAnimation, captionAnimation) =
//        DispatchQueue.global().sync {
            (
                gradientColorsAnimation(using: gradientLayer.colors),
                ringLayerAnimation(),
                squareLayerAnimation(
                    from: squareLayer.position.x - 60,
                    toValue: squareLayer.position.x + 60
                ),
                captionLayerAnimation()
            )
//        }
        
        gradientLayer.add(gradientAnimation, forKey: "gradientColorShift")
        view.layer.addSublayer(gradientLayer)
        
        let ringLayer = ringLayer()
        
        gradientLayer.addSublayer(ringLayer)
        ringLayer.add(ringAnimation, forKey: "ringDrawAndSpin")
        
        squareLayer.add(squareAnimation, forKey: "squareMoveLeftRight")
        gradientLayer.addSublayer(squareLayer)
        
        let captionLayer = captionLayer()
        gradientLayer.addSublayer(captionLayer)
        
        captionLayer.add(captionAnimation, forKey: "captionTransform")
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
    
    private func captionLayer() -> CATextLayer {
        let captionLayer = CATextLayer()
        
        captionLayer.bounds = CGRect(
            x: 0,
            y: 0,
            width: bounds.width - 40,
            height: 30
        )
        captionLayer.position = CGPoint(x: bounds.width / 2, y: bounds.height / 4)
        
        captionLayer.string = "CALayer Hierarchy"
        captionLayer.font = UIFont.boldSystemFont(ofSize: 20)
        captionLayer.fontSize = 20
        captionLayer.alignmentMode = .center
        captionLayer.foregroundColor = UIColor.white.cgColor
        
        return captionLayer
    }
    
    private func captionLayerAnimation() -> CABasicAnimation {
        var start = CATransform3DIdentity
        start.m34 = -1.0 / 500.0
        start = CATransform3DScale(start, 0.85, 0.85, 1)

        var end = CATransform3DIdentity
        end.m34 = -1.0 / 500.0
        end = CATransform3DRotate(end, .pi / 10, 0, 1, 0)
        end = CATransform3DScale(end, 1.1, 1.1, 1)

        let transformAnimation = CABasicAnimation(keyPath: "transform")
        transformAnimation.fromValue = start
        transformAnimation.toValue = end
        
        transformAnimation.duration = 1.8
        transformAnimation.autoreverses = true
        transformAnimation.repeatCount = .infinity
        transformAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        return transformAnimation
    }
    
}
