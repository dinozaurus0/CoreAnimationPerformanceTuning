import XCTest
import UIKit
import CoreAnimationPerformanceTuning

final class LayerPerformanceTests: XCTestCase {
    func testSetupLayersPerformance() {
        let viewController = viewController()

        measureMetrics(
            [.wallClockTime],
            automaticallyStartMeasuring: false
        ) {
            viewController.view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            
            let expectation = expectation(description: "finish executing")
            
            startMeasuring()
            
            viewController.setupLayers(
                didFinish: {
                    expectation.fulfill()
                }
            )
            
            wait(for: [expectation], timeout: 5.0)
            
            stopMeasuring()
            
        }
    }
    
    private func viewController() -> ViewController {
        let viewController = ViewController()
        viewController.loadViewIfNeeded()
        viewController.view.frame = CGRect(x: 0, y: 0, width: 390, height: 844)
        return viewController
    }
}
