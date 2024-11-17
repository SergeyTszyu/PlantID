import UIKit

enum ScannerType: Int {
    case identify
    case diagnose
}

@objc protocol ScannerFirstViewControllerDelegate: AnyObject {
    func scannerFirstViewController(_ controller: ScannerFirstViewController, scannerType type: Int)
    func scannerFirstViewControllerDismiss(_ controller: ScannerFirstViewController)
}

class ScannerFirstViewController: BaseViewController {

    private var blurEffectView: UIVisualEffectView!
    private var scannerType: ScannerType = .identify
    weak var delegate: ScannerFirstViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.08)
        setupBlurEffect()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.backgroundColor = .clear
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)
    }
    
    @objc func identifyAction(_ sender: UIButton) {
        scannerType = .identify
        let vc = ScannerViewController()
        vc.scannerType = .identify
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func diagnoseAction(_ sender: UIButton) {
        scannerType = .diagnose
        let vc = ScannerViewController()
        vc.scannerType = .diagnose
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
