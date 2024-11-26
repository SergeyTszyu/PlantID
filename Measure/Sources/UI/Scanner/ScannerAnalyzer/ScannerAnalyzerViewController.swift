//
//  ScannerAnalyzerViewController.swift
//  PlantNEW

import UIKit
import Lottie

class ScannerAnalyzerViewController: BaseViewController {
    
    @IBOutlet private weak var scanningImageView: UIImageView!
//    @IBOutlet private var animationScanView: UIView!
    
    var scanningImage: UIImage!
    private var animationView: LottieAnimationView?
    var scannerType: ScannerType = .identify

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanningImageView.image = scanningImage
        
        animationView = .init(name: "AnimationScan")
        animationView!.frame = scanningImageView.bounds
        animationView!.contentMode = .scaleAspectFill
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 1.0
        scanningImageView.addSubview(animationView!)
        animationView!.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
