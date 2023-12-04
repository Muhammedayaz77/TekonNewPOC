//
//  ViewController.swift
//  TekonNewPOC
//
//  Created by Muhammed Ayaz on 16/11/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        
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

