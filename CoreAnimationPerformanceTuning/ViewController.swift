import UIKit

final class ViewController: UIViewController {
    
    private var gradientLayer = CAGradientLayer()
    private var bounds: CGRect = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bounds = view.bounds
        setupLayers()
    }
    
    private func setupLayers() {
        self.setupGradientLayer()
    }
    
    private func setupGradientLayer() {
        gradientLayer.bounds = bounds
        gradientLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        
        gradientLayer.colors = [
            UIColor.systemPurple.cgColor,
            UIColor.systemBlue.cgColor,
            UIColor.systemTeal.cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        DispatchQueue.main.async {
            self.view.layer.addSublayer(self.gradientLayer)
        }
    }
    
}
