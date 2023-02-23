//
//  QRScanViewController.swift
//  qrcode
//
//  Created by Quang Tran on 2/6/21.
//

import UIKit
import AVKit
import RxSwift
import RxCocoa
import RealmSwift
import MLKitVision
import MLKitBarcodeScanning

class QRScanViewController: QRViewController, QRBannerEmbed {
    override var preferNavigationBarHidden: Bool { return true }
    
    weak var previewView: PreviewView!
    weak var scanIndicator: QRScanView!
    weak var pickPhotoButton: UIButton!
    weak var flashButton: UIButton!
    
    //sourcery:begin: superView = previewView
    //sourcery:end
    
    //sourcery:begin: ignore
    let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                              for: .video, position: .unspecified)
    let captureSession = AVCaptureSession()
    var schedule: Observable<Int>?
    var sessionShouldDetect = true
    let flashOn = BehaviorRelay<Bool>(value: false)
    let outputQueue = DispatchQueue(label: "com.unitvn.qrcode.VideoDataOutputQueue")
    //sourcery:end
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createViews()
        setupViews()
        createConstraints()
        setupCaptureSession()
        setupFlash()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
        
        scanIndicator.scanIndicator.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
}

extension QRScanViewController {
    func setupFlash() {
        flashOn.subscribe(onNext: {[weak self] isOn in
            self?.toggleFlash(isOn: isOn)
        }).disposed(by: disposeBag)
    }
    
    func toggleFlash(isOn: Bool) {
        guard let device = self.videoDevice else { return }
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            
            if !isOn {
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    print(error)
                }
            }
            
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    @objc func showImagePicker() {
        QRImagePicker.show(from: self) {[weak self] image in
            guard let `self` = self, let image = image else { return }
            self.detectQRInImage(image)
        }
    }
    
    func detectQRInImage(_ qrcodeImg: UIImage) {
        sessionShouldDetect = false
        let image = VisionImage(image: qrcodeImg)
        image.orientation = qrcodeImg.imageOrientation
        outputQueue.async {[weak self] in
            self?.scanBarcodesOnDevice(in: image, width: qrcodeImg.size.width, height: qrcodeImg.size.height)
        }
    }
}

extension QRScanViewController {
    func found(code: Barcode) {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        saveHistory(code: code)
        
        DispatchQueue.main.async {[weak self] in
            let resultVM = VMCodeResult(code: QRCode(stringValue: code.rawValue ?? "", codeType: code.format))
            let viewController = QRScanResultViewController(viewModel: resultVM)
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func saveHistory(code: Barcode) {
        let realm = try! Realm()
        let object = RLMScanHistory()
        object.code = code.rawValue ?? ""
        object.codeType = code.format.rawValue
        try! realm.write {
            realm.add(object)
        }
    }
    
    func pauseSession(for seconds: Double) {
        sessionShouldDetect = false
        
        let schedule = Observable<Int>.interval(.nanoseconds(Int(seconds * 1000000000)), scheduler: MainScheduler.instance)
        
        schedule
            .skip(1)
            .take(1)
            .subscribe(onNext: {[weak self] _ in
            self?.sessionShouldDetect = true
        }).disposed(by: disposeBag)
        
        self.schedule = schedule
    }
    
    private func scanBarcodesOnDevice(in image: VisionImage, width: CGFloat, height: CGFloat) {
        // Define the options for a barcode detector.
        let format = BarcodeFormat.all
        let barcodeOptions = BarcodeScannerOptions(formats: format)
        
        // Create a barcode scanner.
        let barcodeScanner = BarcodeScanner.barcodeScanner(options: barcodeOptions)
        var barcodes: [Barcode]
        do {
            barcodes = try barcodeScanner.results(in: image)
        } catch let error {
            print("Failed to scan barcodes with error: \(error.localizedDescription).")
            return
        }
        
        guard let barcode = barcodes.first else {
            return
        }
        
        pauseSession(for: 1)
        
        found(code: barcode)
    }
}

extension QRScanViewController {
    func setupCaptureSession() {
        captureSession.beginConfiguration()
        guard let videoDevice = self.videoDevice else { return }
        guard
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
            captureSession.canAddInput(videoDeviceInput)
        else { return }
        captureSession.addInput(videoDeviceInput)
        
        let output = AVCaptureVideoDataOutput()
        if (captureSession.canAddOutput(output)) {
            captureSession.addOutput(output)
            output.videoSettings = [
                (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA
            ]
            output.alwaysDiscardsLateVideoFrames = true
            output.setSampleBufferDelegate(self, queue: outputQueue)
        } else {
            return
        }
        
        captureSession.commitConfiguration()
    }
    
    func imageOrientation(
        fromDevicePosition devicePosition: AVCaptureDevice.Position = .back
    ) -> UIImage.Orientation {
        var deviceOrientation = UIDevice.current.orientation
        if deviceOrientation == .faceDown || deviceOrientation == .faceUp
            || deviceOrientation
            == .unknown
        {
            deviceOrientation = currentUIOrientation()
        }
        switch deviceOrientation {
        case .portrait:
            return devicePosition == .front ? .leftMirrored : .right
        case .landscapeLeft:
            return devicePosition == .front ? .downMirrored : .up
        case .portraitUpsideDown:
            return devicePosition == .front ? .rightMirrored : .left
        case .landscapeRight:
            return devicePosition == .front ? .upMirrored : .down
        case .faceDown, .faceUp, .unknown:
            return .up
        @unknown default:
            fatalError()
        }
    }
    
    func currentUIOrientation() -> UIDeviceOrientation {
        let deviceOrientation = { () -> UIDeviceOrientation in
            switch UIApplication.shared.statusBarOrientation {
            case .landscapeLeft:
                return .landscapeRight
            case .landscapeRight:
                return .landscapeLeft
            case .portraitUpsideDown:
                return .portraitUpsideDown
            case .portrait, .unknown:
                return .portrait
            @unknown default:
                fatalError()
            }
        }
        guard Thread.isMainThread else {
            var currentOrientation: UIDeviceOrientation = .portrait
            DispatchQueue.main.sync {
                currentOrientation = deviceOrientation()
            }
            return currentOrientation
        }
        return deviceOrientation()
    }
}

extension QRScanViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard sessionShouldDetect else { return }
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Failed to get image buffer from sample buffer.")
            return
        }
        let visionImage = VisionImage(buffer: sampleBuffer)
        let orientation = imageOrientation(
            fromDevicePosition: videoDevice?.position ?? .unspecified
        )
        
        visionImage.orientation = orientation
        let imageWidth = CGFloat(CVPixelBufferGetWidth(imageBuffer))
        let imageHeight = CGFloat(CVPixelBufferGetHeight(imageBuffer))
        scanBarcodesOnDevice(in: visionImage, width: imageWidth, height: imageHeight)
    }
}

extension QRScanViewController: ViewControllerAutoCreateViews {
    func setupViews() {
        previewView.videoPreviewLayer.videoGravity = .resizeAspectFill
        previewView.videoPreviewLayer.session = captureSession
        
        view.bringSubviewToFront(bannerView)
        
        pickPhotoButton.style {
            $0.setImage(UIImage(named: "qrcode")?.withRenderingMode(.alwaysOriginal), for: .normal)
            $0.contentEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
            $0.backgroundColor = .backgroundColor
            $0.layer.cornerRadius = 5
            $0.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
        }
        
        flashOn.subscribe(onNext: {[weak self] isOn in
            let imageName = isOn ? "flash_on_ic" : "flash_off_ic"
            let image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
            self?.flashButton.setImage(image, for: .normal)
        }).disposed(by: disposeBag)
        
        flashButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let `self` = self else { return }
            let isOn = self.flashOn.value
            self.flashOn.accept(!isOn)
        }).disposed(by: disposeBag)
    }
    
    func createConstraints() {
        previewView
            .top(0)
            .fillHorizontally()
            .bottom(bottomAnchor)
        
        bannerView
            .top(topAnchor)
            .fillHorizontally()
        
        scanIndicator
            .followEdges(previewView)
        
        pickPhotoButton
            .bottom(bottomAnchor, constant: -20)
            .leading(leadingAnchor, constant: 20)
            .width(50)
            .heightEqualsWidth()
        
        flashButton
            .bottom(bottomAnchor, constant: -20)
            .trailing(trailingAnchor, constant: -20)
            .heightEqualsWidth()
            .width(35)
    }
}
