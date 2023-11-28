//
//  AlertManager.swift
//  TekonNewPOC
//
//  Created by Muhammed Ayaz on 27/11/23.
//

import UIKit

class AlertManager: NSObject {
    static let sharedInstance = AlertManager()

        //Show alert
        func alert(view: UIViewController, title: String, message: String) {
            /*
            // Example usage
            SharedClass.sharedInstance.alert(view: self, title: "Your title here", message: "Your message here")
            */
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            })
            alert.addAction(defaultAction)
            DispatchQueue.main.async(execute: {
                view.present(alert, animated: true)
            })
        }
    
        private override init() {
        }
    
    func alertWindow(title: String, message: String) {
        /*
        // Example usage
        SharedClass.sharedInstance.alertWindow(title:"This your title", message:"This is your message")
         */
        
        DispatchQueue.main.async(execute: {
            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
            alertWindow.rootViewController = UIViewController()
            alertWindow.windowLevel = UIWindow.Level.alert + 1
        
            let alert2 = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let defaultAction2 = UIAlertAction(title: "OK", style: .default, handler: { action in
            })
            alert2.addAction(defaultAction2)
        
            alertWindow.makeKeyAndVisible()
        
            alertWindow.rootViewController?.present(alert2, animated: true, completion: nil)
        })
    }
    
    
    
}


