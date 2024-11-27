//
//  ScannerAnalyzerViewController.swift
//  PlantNEW

import UIKit
import Lottie

final class ScannerAnalyzerViewController: BaseViewController {
    
    @IBOutlet private weak var scanningImageView: UIImageView!
    
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
        
        scan()
    }
    
    func scan() {
        let manager = ScannerManager()
        manager.scannerType = scannerType
        manager.scanningImage = scanningImage
        manager.setup()
        manager.onScanCompleted = { [weak self] response in
            if self!.scannerType == .identify {
                let vc = ScannerResultIdentify()
                vc.image = self!.scanningImage
                vc.result = response
                DispatchQueue.main.async {
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
            }
        }
        manager.onScanHealthCompleted = { [weak self] response in
            let vc = ScannerResultIdentify()
            vc.image = self!.scanningImage
            vc.resultHealty = response
            vc.scannerType = .diagnose
            DispatchQueue.main.async {
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        manager.onScanIsHealthy = {
            DispatchQueue.main.async {
                let vc = ScannerNotFoundViewController()
                vc.ccannerResultType = .isHealthy
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        manager.onScanNotFound = {
            DispatchQueue.main.async {
                let vc = ScannerNotFoundViewController()
                vc.ccannerResultType = .notFound
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
