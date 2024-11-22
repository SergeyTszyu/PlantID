//
//  Onboarding1ViewController.swift
//  PlantNEW

import UIKit

@objc protocol Onboarding1ViewControllerDelegate: AnyObject {
    func onboarding1ViewControllerNext(_ onboarding1ViewController: Onboarding1ViewController)
}

class Onboarding1ViewController: BaseViewController {
    
    @IBOutlet private weak var onbImageeView: UIImageView!
    @IBOutlet private weak var onbTopTextLabel: UILabel!
    @IBOutlet private weak var onbBottomTextLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(hexString: "#000000")!.withAlphaComponent(0.2).cgColor,
            UIColor(hexString: "#000000")!.withAlphaComponent(0.2).cgColor
        ]
        layer.startPoint = CGPoint(x: 0.5, y: 0.0) // Начало сверху
        layer.endPoint = CGPoint(x: 0.5, y: 1.0)   // Конец снизу
        return layer
    }()
    
    weak var delegate: Onboarding1ViewControllerDelegate?
    
    private func addGradient() {
        gradientLayer.frame = onbImageeView.bounds
        onbImageeView.layer.addSublayer(gradientLayer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = onbImageeView.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onbImageeView.image = UIImage(named: "Onboarding2")
        addGradient()
    }


}
