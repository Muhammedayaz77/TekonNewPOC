//
//  AppDelegate.swift
//  TekonNewPOC
//
//  Created by Muhammed Ayaz on 16/11/23.
//

/*
 alamofire package URL "https://github.com/Alamofire/Alamofire.git"
 */

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
//    let backgroundSessionIdentifier = "com.example.backgroundSession"
//    let backgroundConfig = URLSessionConfiguration.background(withIdentifier: backgroundSessionIdentifier)
//    let backgroundSessionManager = Alamofire.Session(configuration: backgroundConfig)
//
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        InternetHandlerNewClass.sharedInstance.startNetworkMoniter()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
  
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        
        let backgroundTask = UIApplication.shared.beginBackgroundTask {
            // Clean up or handle task completion if needed
        }

        // Perform your upload operation here
        //uploadFilesInBackground()

        // End the background task when the upload is complete
        //UIApplication.shared.endBackgroundTask(backgroundTask)
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        AppStateManager.shared.appDidEnterBackground()
    }
    
    
    
    
}
