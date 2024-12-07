//
//  ScannerViewController.swift
//  PlantID

import UIKit
import AVFoundation
import ApphudSDK

class ScannerViewController: UIViewController,
                                UIImagePickerControllerDelegate,
                                UINavigationControllerDelegate,
                                AVCapturePhotoCaptureDelegate {
    
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var cameraView: UIView!
    private var photoOutput: AVCapturePhotoOutput!
    
    var scannerType: ScannerType = .identify
    private var isFlashOn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCameraPermission()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let cameraView = cameraView {
            cameraView.frame = view.bounds
        }
        if let previewLayer = previewLayer {
            previewLayer.frame = cameraView?.bounds ?? view.bounds
        }
    }

    
    private func checkCameraPermission() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if granted {
                        self.handleCameraAccessGranted()
                    } else {
                        self.handleCameraAccessDenied()
                    }
                }
            }

        case .authorized:
            handleCameraAccessGranted()

        case .denied, .restricted:
            handleCameraAccessDenied()

        @unknown default:
            handleCameraAccessDenied()
        }
    }
    
    private func handleCameraAccessGranted() {
        startCameraSession()
        setupCameraView()
    }

    private func handleCameraAccessDenied() {
        let alertController = UIAlertController(
            title: "Camera Access Denied",
            message: "To use this app, please allow access to your camera in Settings.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupCameraView() {
        cameraView = UIView(frame: view.bounds)
        cameraView.backgroundColor = .black
        view.addSubview(cameraView)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = cameraView.bounds
        previewLayer.videoGravity = .resizeAspectFill
        cameraView.layer.addSublayer(previewLayer)
        view.sendSubviewToBack(cameraView)
    }
    
    private func startCameraSession() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        guard let camera = AVCaptureDevice.default(for: .video) else {
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch { return }
        photoOutput = AVCapturePhotoOutput()
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
        captureSession.startRunning()
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func flashAction(_ sender: UIButton) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else {
             return
         }
         do {
             try device.lockForConfiguration()
             if isFlashOn {
                 device.torchMode = .off
                 isFlashOn = false
             } else {
                 try device.setTorchModeOn(level: 1.0)
                 isFlashOn = true
             }
             device.unlockForConfiguration()
         } catch {
         }
    }
    
    @IBAction func mediaAction(_ sender: UIButton) {
        if canPerformScan() {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = false
            present(imagePickerController, animated: true, completion: nil)
        } else {
            let paywallViewController = PaywallViewController()
            paywallViewController.modalPresentationStyle = .overFullScreen
            paywallViewController.modalTransitionStyle = .crossDissolve
            self.present(paywallViewController, animated: true)
        }
    }
    
    @IBAction func photoAction(_ sender: UIButton) {
        if Apphud.hasActiveSubscription() {
            let photoSettings = AVCapturePhotoSettings()
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
        } else if canPerformScan() {
            let photoSettings = AVCapturePhotoSettings()
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
        } else {
            let paywallViewController = PaywallViewController()
            paywallViewController.modalPresentationStyle = .overFullScreen
            paywallViewController.modalTransitionStyle = .crossDissolve
            self.present(paywallViewController, animated: true)
        }
    }
    
    func incrementScanCount() {
//        let currentCount = UserDefaults.standard.integer(forKey: "countOfScans")
//        UserDefaults.standard.set(currentCount + 1, forKey: "countOfScans")
    }
    
    func canPerformScan() -> Bool {
        let scansCount = UserDefaults.standard.integer(forKey: "countOfScans")
        
        if scansCount >= 1 {
            return false
        }
        return true
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
         if let _ = error {
             return
         }
         
         guard let imageData = photo.fileDataRepresentation(),
               let image = UIImage(data: imageData) else {
             return
         }
        
        incrementScanCount()
        let vc = ScannerAnalyzerViewController()
        vc.scannerType = scannerType
        vc.scanningImage = image
        self.navigationController?.pushViewController(vc, animated: true)
     }
    
    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = false
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            incrementScanCount()
            let vc = ScannerAnalyzerViewController()
            vc.scannerType = scannerType
            vc.scanningImage = image
            self.navigationController?.pushViewController(vc, animated: true)
        }
        picker.dismiss(animated: true)
    }
}

extension ScannerViewController: ScannerFirstViewControllerDelegate {
    
    func scannerFirstViewController(_ controller: ScannerFirstViewController, scannerType type: Int) {
        let type = ScannerType(rawValue: type)!
        scannerType = type
    }
    
    func scannerFirstViewControllerDismiss(_ controller: ScannerFirstViewController) {
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.selectedIndex = 0
    }
}
