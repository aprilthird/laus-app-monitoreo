//
//  ReadQRCodeViewController.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import UIKit
import AVFoundation

class ReadQRCodeViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var frameImageView: UIImageView!
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var closeButton: UIButton!
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    var readQRCodePresenter: ReadQRCodePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = Constants.Localizable.QR_CODE_READER_TITLE
        
        captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video),
            let videoInput = try? AVCaptureDeviceInput(device: captureDevice) else {
                // TODO: Send non fatal error
                return
        }
        captureSession.addInput(videoInput)
        let metadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(metadataOutput)
        metadataOutput.metadataObjectTypes = [.qr]
        metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = frameImageView.bounds
        previewLayer.videoGravity = .resizeAspectFill
        frameImageView.layer.addSublayer(previewLayer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = nil
        
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        frameImageView.layer.cornerRadius = frameImageView.bounds.height / 30
        closeButton.layer.cornerRadius = closeButton.bounds.height / 2
        closeButton.backgroundColor = readQRCodePresenter.getCloseButtonBackgroundColor()
    }
    
    @IBAction func didCloseView(_ sender: Any) {
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ReadQRCodeViewController: ReadQRCodeViewControllerProtocol {
    func showQRCodeStatus(_ status: QRCodeStatus?, _ name: String?, _ date: String?) {
        let qrCodeStatus = Router.shared.getQRCodeStatus(status: status, name: name, date: date)
        qrCodeStatus.modalPresentationStyle = .overCurrentContext
        qrCodeStatus.modalTransitionStyle = .crossDissolve
        present(qrCodeStatus, animated: true, completion: nil)
    }
}
extension ReadQRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
            return
        }
        
        readQRCodePresenter.validateQRCode(metadataObject.stringValue)
    }
}
