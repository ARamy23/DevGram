//
//  CameraVC.swift
//  Devgram
//
//  Created by ScaRiLiX on 10/3/18.
//  Copyright © 2018 ScaRiLiX. All rights reserved.
//

import UIKit
import AVFoundation

class CameraVC: UIViewController {
    
    //MARK:- UI Init
    
    lazy var captureButton: UIButton =
    {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "capture_photo").original, for: .normal)
        btn.addTarget(self, action: #selector(handleCapturingPhoto), for: .touchUpInside)
        return btn
    }()
    
    lazy var dismissButton: UIButton =
    {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "right_arrow_shadow").original, for: .normal)
        btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return btn
    }()
    
    //MARK:- Instance Vars
    
    let customAnimationPresentor = CustomAnimationPresentor()
    let customAnimationDismisser = CustomAnimationDismisser()
    
    //MARK:- Helpers
    
    let output = AVCapturePhotoOutput()
    
    //MARK:- View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitioningDelegate = self
        setupCaptureSession()
        setupUI()
    }
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    //MARK:- Setup Methods
    
    fileprivate func setupCaptureSession()
    {
        let captureSession = AVCaptureSession()
        
        setupInputs(for: captureSession)
        
        if captureSession.canAddOutput(output) { captureSession.addOutput(output) }
        
        setupOutputPreview(for: captureSession)
        
        captureSession.startRunning()
    }
    
    fileprivate func setupInputs(for captureSession: AVCaptureSession)
    {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        do
        {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) { captureSession.addInput(input) }
        }
        catch let err
        {
            print("couldn't set camera input\n")
            print(err)
        }
    }
    
    fileprivate func setupOutputPreview(for captureSession: AVCaptureSession)
    {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
    }
    
    fileprivate func setupUI()
    {
        view.addSubview(captureButton)
        view.addSubview(dismissButton)
        
        setupCaptureButton()
        setupDismissButton()
    }
    
    fileprivate func setupDismissButton()
    {
        dismissButton.snp.makeConstraints { (maker) in
            maker.top.right.equalTo(view).inset(12)
            maker.size.equalTo(50)
        }
    }
    
    fileprivate func setupCaptureButton()
    {
        captureButton.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(view).inset(24)
            maker.centerX.equalTo(view)
            maker.size.equalTo(80)
        }
    }
    
    //MARK:- Logic
    
    @objc fileprivate func handleCapturingPhoto()
    {
        
        let settings = AVCapturePhotoSettings()
        
        #if (!arch(x86_64))
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        
        output.capturePhoto(with: settings, delegate: self)
        #endif
    }
    
    @objc fileprivate func handleDismiss()
    {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CameraVC: AVCapturePhotoCaptureDelegate
{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let previewImage = UIImage(data: imageData)
        let containerView = PhotoPreviewContainerView()
        
        containerView.previewImageView.image = previewImage
        containerView.delegate = self
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalTo(view)
        }
    }
}

extension CameraVC: SharingPhotoDelegate
{
    func didSelectSharing(_ previewImage: UIImage) {
        let sharingVC = SharePhotoVC()
        sharingVC.imageView.image = previewImage
        let navCon = UINavigationController(rootViewController: sharingVC)
        present(navCon, animated: true, completion: nil)
    }
}

extension CameraVC: UIViewControllerTransitioningDelegate
{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return customAnimationPresentor
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return customAnimationDismisser
    }
}
