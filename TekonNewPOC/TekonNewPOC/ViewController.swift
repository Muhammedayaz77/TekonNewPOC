//
//  ViewController.swift
//  TekonNewPOC
//
//  Created by Muhammed Ayaz on 16/11/23.
//

import UIKit
import Photos
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        requestGalleryPermission()
        checkCameraPermission()
        checkGalleryPermission()
        checkCameraPermission()
        
        print("DocumentDirectoriesPath", getDocumentDirectoriesPath())
        
        AppStateManager.shared.appState
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            // your function here
            self.SwitchToMediaListViewController()
        }
    }
    
    
    func checkGalleryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            print("Gallery permission authorized")
        case .denied, .restricted:
            print("Gallery permission denied")
        case .notDetermined:
            print("Gallery permission not determined")
            
        default:
            break
        }
    }

    func checkCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            print("Camera permission authorized")
        case .denied, .restricted:
            print("Camera permission denied")
        case .notDetermined:
            print("Camera permission not determined")
        default:
            break
        }
    }
    
    func requestGalleryPermission() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                // Permission granted, you can now access the photo library
                print("Gallery permission granted")
            case .denied, .restricted:
                // Permission denied or restricted by parental controls
                print("Gallery permission denied")
            case .notDetermined:
                // User has not yet made a choice
                print("Gallery permission not determined")
            default:
                break
            }
        }
    }
    
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                // Permission granted, you can now access the camera
                print("Camera permission granted")
            } else {
                // Permission denied
                print("Camera permission denied")
            }
        }
    }



    
    func SwitchToMediaViewController () {
        
        // Register Nib
        let viewController = MediaViewController(nibName: "MediaViewController", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(viewController, animated: false, completion: nil)
    }

    
    func SwitchToMediaListViewController () {
        
        // Register Nib
        let viewController = MediaListViewController(nibName: "MediaListViewController", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(viewController, animated: false, completion: nil)
    }
    
}

